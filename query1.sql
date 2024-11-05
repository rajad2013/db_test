WITH LastBalance AS (
    SELECT Account_Number, BALANCE, DATE AS balance_date
    FROM BALANCE
    WHERE Account_Number = 'YOUR_ACCOUNT_NUMBER'  -- Specify the account number here
    ORDER BY DATE DESC
    LIMIT 1
),
FilteredTransactions AS (
    SELECT t.*
    FROM Transaction t
    JOIN LastBalance lb 
      ON t.Account_Number = lb.Account_Number  -- Match account numbers
      AND t.DATE >= lb.balance_date  -- Only include transactions from the balance date onward
    WHERE t.Account_Number = 'YOUR_ACCOUNT_NUMBER'  -- Specify the account number here
)
SELECT 
    ft.Account_Number,
    ft.ID,
    ft.DATE,
    ft.AMOUNT,
    ft.TYPE,
    COALESCE(
        SUM(CASE 
                WHEN ft.TYPE = 'C' THEN ft.AMOUNT  -- Add for Credit
                WHEN ft.TYPE = 'D' THEN -ft.AMOUNT  -- Subtract for Debit
                ELSE 0 
             END
        ) OVER (ORDER BY ft.DATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
        + lb.BALANCE,
        lb.BALANCE
    ) AS RUNNING_BALANCE
FROM FilteredTransactions ft
JOIN LastBalance lb ON ft.Account_Number = lb.Account_Number  -- Cross join for starting balance
ORDER BY ft.DATE;
