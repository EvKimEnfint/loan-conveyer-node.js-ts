import { addClientAndPassport } from '../service/application.service.js';
import axios from 'axios';
import { db } from '../db.js';
import pgPromise from 'pg-promise';
import { BadRequestError, ServerError, ConflictError, AuthorizationError, ValidationError, ResourceNotFoundError } from '../errors/errorClasses.js';
import { logger } from '../helpers/logger.js';
export const postApplication = async (req, res, next) => {
    try {
        const loanApplication = req.body;
        const clientId = await addClientAndPassport(loanApplication);
        const applicationResult = await db.one('INSERT INTO application(client_id, creation_date, status) VALUES($1, $2, $3) RETURNING application_id', [clientId, new Date(), 'CC_DENIED']);
        const applicationId = applicationResult.application_id;
        const response = await axios.post('http://api-conveyer:3001/conveyor/offers', loanApplication);
        if (!response.data) {
            throw new ServerError('Не удалось получить предложения о кредите с API Conveyor.');
        }
        const loanOffers = response.data.map((offer) => {
            return { ...offer, applicationId: applicationId };
        });
        logger.info(`Successfully processed application for client ID: ${clientId}.`);
        res.status(200).json(loanOffers);
    }
    catch (error) {
        logger.error('Error calculating loan offer', error);
        if (error instanceof BadRequestError ||
            error instanceof AuthorizationError ||
            error instanceof ValidationError ||
            error instanceof ResourceNotFoundError ||
            error instanceof ConflictError ||
            error instanceof ServerError) {
            return next(error);
        }
        if (error instanceof pgPromise.errors.QueryResultError) {
            return next(new ServerError('Ошибка при выполнении запроса к базе данных.'));
        }
        return next(new ServerError('Внутренняя ошибка сервера.'));
    }
};
//# sourceMappingURL=application.controller.js.map