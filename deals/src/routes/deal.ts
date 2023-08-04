import express, { NextFunction } from 'express';
const router = express.Router();
import { postApplication } from '../controllers/application.controller.js';
import { handleOfferUpdate } from "../controllers/offer.controller.js";
import { calculateCredit } from '../controllers/calculate.controller.js';
import { validateLoanApplicationBody } from '../middlewares/validateLoanApplicationBody.js';
import { validateLoanOffer } from '../middlewares/validateLoanOffer.js';
import { validateRegistrationData } from '../middlewares/vlidateFinishRegistrationData.js';
import { sendDocuments } from '../controllers/sendDocuments.controller.js';
import { sendSes } from '../controllers/sendSes.controller.js';
import { sendCode } from '../controllers/sendCode.controller.js';


router.post('/application', validateLoanApplicationBody, postApplication);

router.put('/offer', validateLoanOffer, handleOfferUpdate);

router.put('/calculate/:applicationId', validateRegistrationData, calculateCredit);

router.post('/document/:applicationId/send', sendDocuments);

router.put('/document/:applicationId/sign', sendSes);

router.put('/document/:applicationId/code', sendCode);

export { router as dealRouter };
