

;WITH CTE_RAW_FEE_DATA
AS(

		select sd.SessionID, ff.Fundname , sd.Amount

			from [7W_trans_SaleDetail] sd

			inner join [dbo].[7W_mst_Fee_Funds] ff 

			on	sd.FundID=ff.id 

			where sd.Amount>0	

),
CTE_PIVOT
AS( 
	SELECT * FROM CTE_RAW_FEE_DATA
	PIVOT
		(
			SUM(Amount)
			FOR	Fundname	IN (
				[ANNUAL CHARGE],
				[FEE BALANCE],
				[SMS CHARGE],
				[PROMOTION FEE],
				[INTERNET CHARGE],
				[LIB CHARGE],
				[TUTION FEES],
				[ADMISSION FEES],
				[TPT fee],
				[TPT])
		)
		AS Pivot_Table
)
SELECT * FROM CTE_PIVOT
