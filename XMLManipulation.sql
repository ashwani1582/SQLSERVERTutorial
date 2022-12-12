


DECLARE @Item_XML	XML

SET @Item_XML='<ItemDetails>
		<item><ItemName>iPhone</ItemName><Amount>55000</Amount></item>
		<item><ItemName>oneplus 10 pro</ItemName><Amount>60000</Amount></item>
		<item><ItemName>samsung s22</ItemName><Amount>70000</Amount></item>
		<item><ItemName>vivo x80 pro</ItemName><Amount>60000</Amount></item>
		<item><ItemName>xiaomi 12 pro</ItemName><Amount>55000</Amount></item>
</ItemDetails>'


	--INSERT INTO	tbl_Item_Details(ItemName,Amount)
	SELECT 

			iTag.iCol.value('ItemName[1]','varchar(100)') as Item_Name,
			iTag.iCol.value('Amount[1]','varchar(100)') as Amount

	FROM	@Item_XML.nodes('/ItemDetails/item') iTag(iCol)


	
	--------------------------------------------------------- Looping XML Starts

	declare @intcountItems int
	declare @intloopItems as int

	set @intcountItems=(select @Item_XML.value('count(//ItemDetails/item)','int'))
		 
	declare @itmmxl	xml

	set @intloopItems =1

	declare  @ItemName varchar(100)
	declare  @Amount varchar(100)
		
	while @intcountItems>0
	Begin
	set @itmmxl=@Item_XML.query('/ItemDetails/*[sql:variable("@intloopItems")]')
			
			--select @itmmxl	
			
			select @ItemName=ItemName  ,@Amount =Amount
			from
			(
				select 
					iTag.iCol.value('ItemName[1]','varchar(100)') as ItemName ,
					iTag.iCol.value('Amount[1]','varchar(100)') as Amount 
					 
				from
				@itmmxl.nodes('/item') iTag(iCol)
			)n
			 


			select @ItemName,@Amount
			INSERT INTO	tbl_Item_Details(ItemName,Amount)
			VALUES(@ItemName,@Amount)

			set @intloopItems=@intloopItems+1
			set @intcountItems=@intcountItems-1
			
	End		


	--truncate table tbl_Item_Details
--------------------------------------------------------- Looping XML Ends
select * from tbl_Item_Details


--------------------------XML Manipulation Live Example


<SelectOptions><item><OptionLabel>A</OptionLabel><OptionQst>\[30m\]
</OptionQst></item><item><OptionLabel>B</OptionLabel><OptionQst>\[10m\]
</OptionQst></item><item><OptionLabel>C</OptionLabel><OptionQst> \[60m\]
</OptionQst></item><item><OptionLabel>D</OptionLabel><OptionQst> \[20m\]
</OptionQst></item></SelectOptions>3




SELECT @SQLXML=optionsXML 

FROM TBL_XML_DATA


SELECT 

		RTRIM(LTRIM(iTag.iCol.value('OptionLabel[1]','nvarchar(max)')))as OptionLabel ,
		RTRIM(LTRIM(iTag.iCol.value('OptionQst[1]','nvarchar(max)'))) as OptionQst 
					 
FROM

@SQLXML.nodes('/SelectOptions/item') iTag(iCol)
