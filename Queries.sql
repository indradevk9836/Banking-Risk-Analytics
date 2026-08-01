--Q1. Find the total number of unique clients.
SELECT COUNT(DISTINCT Client_ID) AS Total_Clients
FROM Clients_Banking;

--Q2. Calculate the total bank deposit amount across all clients.
  SELECT SUM(Bank_Deposits) AS Bank_Deposit
FROM Clients_Banking;

--Q3. Calculate Total Deposit (Bank Deposit + Savings + Foreign Currency + Checking).
  SELECT SUM(Bank_Deposits + Savings_Account + Foreign_Currency_Account + Checking_Accounts) AS Total_Deposit
FROM Clients_Banking;

--Q4. Calculate Total Loan (Bank Loan + Business Lending + Credit Card Balance).
  SELECT SUM(Bank_Loans + Business_Lending + Credit_Card_Balance) AS Total_Loan
FROM Clients_Banking;

--Q5. Create an Income Band column: 'Low' if Estimated Income < 100000, 'Mid' if < 300000, else 'High'.
  SELECT 
    Client_ID,
    Estimated_Income,
    CASE 
        WHEN Estimated_Income < 100000 THEN 'Low'
        WHEN Estimated_Income < 300000 THEN 'Mid'
        ELSE 'High'
    END AS Income_Band
FROM Clients_Banking;

--Q6. Create a Processing Fees column based on Fee Structure ('High' = 0.05, 'Mid' = 0.03, 'Low' = 0.01).
  SELECT 
    Client_ID,
    Fee_Structure,
    CASE 
        WHEN Fee_Structure = 'High' THEN 0.05
        WHEN Fee_Structure = 'Mid' THEN 0.03
        WHEN Fee_Structure = 'Low' THEN 0.01
        ELSE 0
    END AS Processing_Fees
FROM Clients_Banking;

--Q7. Calculate Total Fees (Total Loan × Processing Fees) for each client.
  SELECT 
    Client_ID,
    (Bank_Loans + Business_Lending + Credit_Card_Balance) *
    CASE 
        WHEN Fee_Structure = 'High' THEN 0.05
        WHEN Fee_Structure = 'Mid' THEN 0.03
        ELSE 0.01
    END AS Total_Fees
FROM Clients_Banking;

--Q8. Calculate Engagement Days (days between Joined Bank date and today) for each client.
  SELECT 
    Client_ID,
    Joined_Bank,
    DATEDIFF(CURRENT_DATE, Joined_Bank) AS Engagement_Days
FROM Clients_Banking;

--Q9. Create an Engagement Timeframe bucket (e.g., <1yr, 1-3yrs, 3-5yrs, 5+yrs) based on Engagement Days.
  SELECT 
    Client_ID,
    DATEDIFF(CURRENT_DATE, Joined_Bank) AS Engagement_Days,
    CASE 
        WHEN DATEDIFF(CURRENT_DATE, Joined_Bank) < 365 THEN '<1 Year'
        WHEN DATEDIFF(CURRENT_DATE, Joined_Bank) BETWEEN 365 AND 1095 THEN '1-3 Years'
        WHEN DATEDIFF(CURRENT_DATE, Joined_Bank) BETWEEN 1096 AND 1825 THEN '3-5 Years'
        ELSE '5+ Years'
    END AS Engagement_Timeframe
FROM Clients_Banking;

--Q10. Find the total Business Lending amount given to clients.
  SELECT SUM(Business_Lending) AS Business_Lending
FROM Clients_Banking;

--Q11. Find the total Credit Card Balance and Total Credit Card Amount separately.
  SELECT 
    SUM(Credit_Card_Balance) AS Total_Credit_Card_Balance,
    SUM(Amount_of_Credit_Cards) AS Total_CC_Amount
FROM Clients_Banking;

--Q12. Find total deposits and total loans grouped by Gender.
  SELECT 
    g.Gender,
    SUM(cb.Bank_Deposits + cb.Savings_Account + cb.Foreign_Currency_Account + cb.Checking_Accounts) AS Total_Deposit,
    SUM(cb.Bank_Loans + cb.Business_Lending + cb.Credit_Card_Balance) AS Total_Loan
FROM Clients_Banking cb
JOIN Gender g ON cb.Gender_ID = g.Gender_ID
GROUP BY g.Gender;

--Q13. Find total loan amount grouped by Investment Advisor.
  SELECT 
    ia.Advisor_Name,
    SUM(cb.Bank_Loans + cb.Business_Lending + cb.Credit_Card_Balance) AS Total_Loan
FROM Clients_Banking cb
JOIN Investment_Advisor ia ON cb.Investment_Advisor_ID = ia.Investment_Advisor_ID
GROUP BY ia.Advisor_Name
ORDER BY Total_Loan DESC;

--Q14. Find the number of clients and total deposits grouped by Banking Relationship type.
  SELECT 
    br.Banking_Relationship,
    COUNT(DISTINCT cb.Client_ID) AS Total_Clients,
    SUM(cb.Bank_Deposits + cb.Savings_Account + cb.Foreign_Currency_Account + cb.Checking_Accounts) AS Total_Deposit
FROM Clients_Banking cb
JOIN Banking_Relationship br ON cb.Banking_Relationship_ID = br.Banking_Relationship_ID
GROUP BY br.Banking_Relationship;

--Q15. Identify clients whose Income Band is 'Low' but who have a High Fee Structure (potential risk cases).
  SELECT Client_ID, Estimated_Income, Fee_Structure
FROM Clients_Banking
WHERE Estimated_Income < 100000
  AND Fee_Structure = 'High';
