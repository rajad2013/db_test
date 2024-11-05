WITH LastKnownBalance AS (
    SELECT BALANCE, DATE
    FROM BALANCE
    ORDER BY DATE DESC
    LIMIT 1
),
FilteredTransactions AS (
    SELECT t.*
    FROM Transaction t
    JOIN LastKnownBalance lb ON t.DATE > lb.DATE
)
SELECT 
    ft.ID,
    ft.DATE,
    ft.AMOUNT,
    ft.TYPE,
    COALESCE(
        SUM(CASE 
                WHEN ft.TYPE = 'C' THEN ft.AMOUNT  -- Credit increases balance
                WHEN ft.TYPE = 'D' THEN -ft.AMOUNT  -- Debit decreases balance
                ELSE 0 
             END
        ) OVER (ORDER BY ft.DATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
        + lb.BALANCE,
        lb.BALANCE
    ) AS RUNNING_BALANCE
FROM FilteredTransactions ft
JOIN LastKnownBalance lb ON 1=1
ORDER BY ft.DATE;
