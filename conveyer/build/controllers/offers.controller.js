import { calculateLoanOffers } from "../services/loanOffers.js";
import { ValidationError, ConflictError, BadRequestError, AuthorizationError, ResourceNotFoundError, ServerError } from "../errors/errorClasses.js";
export const createOffers = async (req, res) => {
    try {
        const loanOffers = calculateLoanOffers(req.body);
        return res.json(loanOffers);
    }
    catch (err) {
        const error = err;
        if (error instanceof BadRequestError) {
            return res.status(400).json({ error: error.message });
        }
        else if (error instanceof AuthorizationError) {
            return res.status(401).json({ error: error.message });
        }
        else if (error instanceof ValidationError) {
            return res.status(403).json({ error: error.message });
        }
        else if (error instanceof ResourceNotFoundError) {
            return res.status(404).json({ error: error.message });
        }
        else if (error instanceof ConflictError) {
            return res.status(409).json({ error: error.message });
        }
        else if (error instanceof ServerError) {
            return res.status(500).json({ error: error.message });
        }
        else {
            return res.status(500).json({ error: "Unexpected error occurred" });
        }
    }
};
//# sourceMappingURL=offers.controller.js.map