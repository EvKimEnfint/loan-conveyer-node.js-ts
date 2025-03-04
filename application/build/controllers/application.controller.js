import axios, { AxiosError } from "axios";
import { ResourceNotFoundError } from "../errors/errorClasses.js";
import { logger } from "../helpers/logger.js";
export const postApplication = async (req, res, next) => {
    try {
        const loanApplicationRequest = req.body;
        logger.info('Received a loan application request:', loanApplicationRequest);
        const response = await axios.post('http://api-deals:3002/deal/application', loanApplicationRequest);
        if (!response.data) {
            logger.warn('Application not found.');
            throw new ResourceNotFoundError('Application not found.');
        }
        logger.info('Successfully processed the loan application request.');
        return res.json(response.data);
    }
    catch (err) {
        if (err instanceof AxiosError) {
            const error = err;
            logger.error('Error occurred while processing the loan application:', error);
            if (error.response) {
                const responseData = error.response.data;
                return res.status(error.response.status).json({ error: responseData || error.message });
            }
            return res.status(400).json({ error: error.message });
        }
        else {
            logger.error('An unexpected error occurred while processing the loan application:', err);
            next();
        }
    }
};
//# sourceMappingURL=application.controller.js.map