import { BadRequestError } from "../errors/errorClasses.js";
import Joi from "joi";
import { Gender, MaritalStatus, EmploymentStatus, Position } from "../types/types.js";
import { isValid } from "date-fns";
const finishRegistrationRequestSchema = Joi.object({
    gender: Joi.string().valid(...Object.values(Gender)).required(),
    maritalStatus: Joi.string().valid(...Object.values(MaritalStatus)).required(),
    dependentNumber: Joi.number().integer().min(0).required(),
    passportIssueDate: Joi.date().iso()
        .custom((value, helpers) => {
        const today = new Date();
        if (value > today || !isValid(value)) {
            return helpers.error("custom.issueDate");
        }
        return value;
    })
        .required()
        .messages({
        'custom.issueDate': 'Invalid passport issue date. The date must not be in the future.',
    }),
    passportIssueBranch: Joi.string().required(),
    employment: Joi.object({
        employmentStatus: Joi.string().valid(...Object.values(EmploymentStatus)).required(),
        employerINN: Joi.string().required(),
        salary: Joi.number().positive().strict().required(),
        position: Joi.string().valid(...Object.values(Position)).required(),
        workExperienceTotal: Joi.number().integer().strict().min(12).required(),
        workExperienceCurrent: Joi.number().integer().strict().min(3).required(),
    }).required(),
    account: Joi.string().required(),
});
export const validateRegistrationData = async (req, res, next) => {
    const { error } = finishRegistrationRequestSchema.validate(req.body);
    if (error) {
        const errorMessage = error.details[0].message;
        const customError = new BadRequestError(errorMessage);
        return next(customError);
    }
    next();
};
//# sourceMappingURL=vlidateFinishRegistrationData.js.map