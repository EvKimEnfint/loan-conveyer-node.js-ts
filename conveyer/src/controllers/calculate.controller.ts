import { Request, Response } from "express";
import { calculateCreditParameters } from "../services/scoreApplication.js";
import { performScoring } from "../services/scoreApplication.js";
import { ScoringDataDTO } from "../dtos.js";
import { ValidationError, BadRequestError, AuthorizationError, ResourceNotFoundError, ConflictError, ServerError } from "../errors/errorClasses.js";

export const calculateLoanOffer = async (req: Request, res: Response) => {
    try {
        const scoringData: ScoringDataDTO = req.body;
        const scoringResult = performScoring(scoringData);
    
        if (!scoringResult.passed) {
            return res.status(400).json({message: scoringResult.message});
        }
    
        const credit = calculateCreditParameters(scoringData, scoringResult.rate);
    
        if (!credit) {
            return res.status(400).json({message: 'The credit cannot be granted.'});
        }
        return res.json(credit);
    } catch (err) {
        const error = err as Error;
        if (error instanceof BadRequestError) {
            return res.status(400).json({ error: error.message });
        } else if (error instanceof AuthorizationError) {
            return res.status(401).json({ error: error.message });
        } else if (error instanceof ValidationError) {
            return res.status(403).json({ error: error.message });
        } else if (error instanceof ResourceNotFoundError) {
            return res.status(404).json({ error: error.message });
        } else if (error instanceof ConflictError) {
            return res.status(409).json({ error: error.message });
        } else if (error instanceof ServerError) {
            return res.status(500).json({ error: error.message });
        } else {
            return res.status(500).json({ error: "Unexpected error occurred" });
        }
    }
    
}