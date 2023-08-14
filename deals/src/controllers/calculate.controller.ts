import { Request, Response, NextFunction } from "express";
import { FinishRegistrationRequestDTO, ScoringDataDTO, Credit, Passport, ClientDTO, ApplicationDTO, PassportDTO } from "../dtos.js";
import { ChangeType, Status, CreditStatus } from "../types/types.js";
import { getFromDb, createScoringDataDTO, 
    saveCreditToDb, saveApplication, updateApplicationStatusAndHistory, updateClient, saveEmploymentToDb, updatePassport, getScoringResponse } from "../service/calculate.service.js";
import { ResourceNotFoundError } from '../errors/errorClasses.js';
import { MessageThemes } from '../types/types.js';
import { EmailMessage } from '../dtos.js';
import { sendKafkaMessage } from "../service/kafka.service.js";
import { logger } from "../helpers/logger.js";

export const calculateCredit = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
      try {
        const applicationId = req.params.applicationId;
        logger.info(`Processing application with ID: ${applicationId}`);

        const finishRegistrationData: FinishRegistrationRequestDTO = req.body;
        logger.info('Received FinisiRegistrationData' + finishRegistrationData);

        const application = await getFromDb<ApplicationDTO>('application', applicationId);

        if (!application) {
          logger.warn(`Application not found for ID: ${applicationId}`);
          throw new ResourceNotFoundError('Application not found.');
        }
        const clientId = JSON.parse(application.client_id);

        const client = await getFromDb<ClientDTO>('client', clientId);

        if (!client) {
          logger.warn(`Client not found for ID: ${clientId}`);
          throw new ResourceNotFoundError('Client not found.');
        }

        const passport = await getFromDb<PassportDTO>('passport', client.passport_id);

        if (!passport) {
          logger.warn(`Passport not found for client ID: ${clientId}`);
          throw new ResourceNotFoundError('Passport not found.');
        }

        const scoringData: ScoringDataDTO = createScoringDataDTO(finishRegistrationData, application, client, passport); 
      
        const scoringResponse = await getScoringResponse(scoringData);

        const creditDTO: Credit = scoringResponse.data;
      
        creditDTO.status = CreditStatus.Calculated;

        if (scoringResponse.status != 200) {
          logger.error(`Scoring failed for application ID: ${applicationId}`);

          const topic = 'application-denied'; 

          const message: EmailMessage = {
            address: client.email,
            theme: MessageThemes.ApplicationDenied, 
            applicationId: applicationId,
            name: client.first_name,
            lastName: client.last_name
          };

          try {
              await sendKafkaMessage(topic, message);
          } catch (error: any) {
              console.error('Failed to send message:', error.message);
          }
        }

        const employmentId = await saveEmploymentToDb(scoringData.employment);

        await updateClient(clientId, scoringData.gender, scoringData.maritalStatus, scoringData.dependentNumber, employmentId, scoringData.account);

        const savedCredit = await saveCreditToDb(creditDTO);

        application.credit_id = savedCredit;
        application.application_id = applicationId;

        await updatePassport(scoringData.passportIssueBranch, scoringData.passportIssueDate, client.passport_id);

        await updateApplicationStatusAndHistory(application, Status.Approved, ChangeType.Automatic);

        await saveApplication(application);  
        console.log(application);
        console.log(client);
        console.log(passport);
        
        const topic = 'create-documents';

        const message: EmailMessage = {
            address: client.email,
            theme: MessageThemes.CreateDocuments, 
            applicationId: applicationId,
            name: client.first_name,
            lastName: client.last_name
        };

        try {
            await sendKafkaMessage(topic, message);
        } catch (error: any) {
            console.error('Failed to send message:', error.message);
        }

        logger.info(`Application status updated successfully for ID: ${applicationId}`);
        res.status(200).json({ message: 'Application status updated successfully.' });
    } catch (err: any) {
        logger.error(`Error occurred during request to ${req.path}: ${err.message}`, { error: err, body: req.body, query: req.query });
        next(err);
    }
};