import Joi from "joi";
import { differenceInYears, isValid, parse } from "date-fns";
import { logger } from "../helpers/logger.js";
import { BadRequestError } from "../errors/errorClasses.js";
const schema = Joi.object({
    firstName: Joi.string().min(2).max(30).required(),
    lastName: Joi.string().min(2).max(30).required(),
    middleName: Joi.string().min(2).max(30).optional(),
    amount: Joi.number().strict().integer().min(10000).required(),
    term: Joi.number().strict().integer().min(6).required(),
    birthdate: Joi.string().custom((value, helpers) => {
        const parsedDate = parse(value, "yyyy-MM-dd", new Date());
        if (!isValid(parsedDate))
            return helpers.error('any.invalid');
        const today = new Date();
        const age = differenceInYears(today, parsedDate);
        if (age < 18)
            return helpers.error('any.invalid');
        return value;
    }, 'Age validation').required(),
    email: Joi.string().email({ tlds: { allow: true } }).required(),
    passportSeries: Joi.string().length(4).pattern(/[0-9]{4}/).required(),
    passportNumber: Joi.string().length(6).pattern(/[0-9]{6}/).required()
});
export const validateLoanApplicationBody = (req, res, next) => {
    logger.info('Получен запрос на валидацию заявки на кредит:', req.body);
    const { error } = schema.validate(req.body);
    if (error) {
        logger.warn('Ошибка валидации:', error);
        return next(new BadRequestError(error.details[0].message));
    }
    next();
};
//# sourceMappingURL=validateLoanApplicationBody.js.map