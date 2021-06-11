--*************************************************************************--
-- Title: Assignment08DB_LuisValderrama
-- Author: Luis Valderrama
-- Desc: This file demonstrates how to use Stored Procedures
-- Change Log: When,Who,What
-- 2021-05-23,Luis Valderrama,Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment08DB_LuisValderrama')
	 Begin 
	  Alter Database [Assignment08DB_LuisValderrama] set Single_user With Rollback Immediate;
	  Drop Database Assignment08DB_LuisValderrama;
	 End
	Create Database Assignment08DB_LuisValderrama;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment08DB_LuisValderrama;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
-- NOTE: We are starting without data this time!

-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, [Count] From dbo.Inventories;
go

/*******************************Please use the database below******************************/

USE Assignment08DB_LuisValderrama;
GO

/********************************* Questions and Answers *********************************/
/* NOTE:Use the following template to create your stored procedures and plan on this taking ~2-3 hours

Create Procedure <pTrnTableName>
 (<@P1 int = 0>)
 -- Author: Luis Valderrama
 -- Desc: Processes <Desc text>
 -- Change Log: When,Who,What
 -- 2021-05-23, Luis Valderrama, Created Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
	-- Transaction Code --
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
*/

-- Question 1 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Categories table?
--Create Procedure pInsCategories

Create Procedure pInsCategories
 (@CategoryName nvarchar (100))
 -- Author: Luis Valderrama
 -- Desc: Insert Sproc
 -- Change Log: When,Who,What
 -- 2021-05-23, Luis Valderrama, Created Insert Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   	Insert Into Categories (CategoryName)
    Values (@CategoryName);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go


--Create Procedure pUpdCategories

Create Procedure pUpdCategories
 (@CategoryID int 
 ,@CategoryName nvarchar (100))
 -- Author: Luis Valderrama
 -- Desc: Update Sproc
 -- Change Log: When,Who,What
 -- 2021-05-23, Luis Valderrama, Created Update Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
     Update Categories
     Set CategoryName = @CategoryName
	 Where CategoryID = @CategoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pDelCategories

Create Procedure pDelCategories
 (@CategoryID int)
 -- Author: Luis Valderrama
 -- Desc: Delete Sproc
 -- Change Log: When,Who,What
 -- 2021-05-23, Luis Valderrama, Created Delete Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
     Delete
	 From Categories
     Where CategoryID = @CategoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Question 2 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Products table?
--Create Procedure pInsProducts

Create Procedure pInsProducts
 (@ProductName nvarchar (100)
 ,@CategoryID int
 ,@UnitPrice money)
 -- Author: Luis Valderrama
 -- Desc: Insert Sproc
 -- Change Log: When,Who,What
 -- 2021-05-23, Luis Valderrama, Created Insert Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   	Insert Into Products(ProductName, CategoryID, UnitPrice)
    Values (@ProductName, @CategoryID, @UnitPrice);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pUpdProducts
Create Procedure pUpdProducts
 (@ProductID int
 ,@ProductName nvarchar (100)
 ,@CategoryID int
 ,@UnitPrice money)
 -- Author: Luis Valderrama
 -- Desc: Update Sproc
 -- Change Log: When,Who,What
 -- 2021-05-23, Luis Valderrama, Created Update Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
     
	 Update Products
     Set ProductName = @ProductName
	   , CategoryID = @CategoryID
	   , UnitPrice = @UnitPrice
	 Where ProductID = @ProductID;
   
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pDelProducts

Create Procedure pDelProducts
 (@ProductID int)
 -- Author: Luis Valderrama
 -- Desc: Delete Sproc
 -- Change Log: When,Who,What
 -- 2021-05-23, Luis Valderrama, Created Delete Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
     Delete
	 From Products
     Where ProductID = @ProductID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Question 3 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Employees table?
--Create Procedure pInsEmployees

Create Procedure pInsEmployees
 (@EmployeeFirstName nvarchar (100)
 ,@EmployeeLastName nvarchar (100)
 ,@ManagerID int)
 -- Author: Luis Valderrama
 -- Desc: Insert Sproc
 -- Change Log: When,Who,What
 -- 2021-05-23, Luis Valderrama, Created Insert Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   	Insert Into Employees(EmployeeFirstName, EmployeeLastName, ManagerID)
    Values (@EmployeeFirstName, @EmployeeLastName, @ManagerID);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pUpdEmployees
Create Procedure pUpdEmployees
 (@EmployeeID int
 ,@EmployeeFirstName nvarchar (100)
 ,@EmployeeLastName nvarchar (100)
 ,@ManagerID int)
 -- Author: Luis Valderrama
 -- Desc: Update Sproc
 -- Change Log: When,Who,What
 -- 2021-05-23, Luis Valderrama, Created Update Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
     Update Employees
     Set EmployeeFirstName = @EmployeeFirstName
	   , EmployeeLastName = @EmployeeLastName
	   , ManagerID = @ManagerID
	 Where EmployeeID = @EmployeeID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pDelEmployees
Create Procedure pDelEmployees
 (@EmployeeID int)
 -- Author: Luis Valderrama
 -- Desc: Delete Sproc
 -- Change Log: When,Who,What
 -- 2021-05-23, Luis Valderrama, Created Delete Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
     Delete
	 From Employees
     Where EmployeeID = @EmployeeID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Question 4 (20 pts): How can you create Insert, Update, and Delete Transactions Store Procedures  
-- for the Inventories table?
--Create Procedure pInsInventories

Create Procedure pInsInventories
 (@InventoryDate date
 ,@EmployeeID int
 ,@ProductID int
 ,@Count int)
 -- Author: Luis Valderrama
 -- Desc: Insert Sproc
 -- Change Log: When,Who,What
 -- 2021-05-23, Luis Valderrama, Created Insert Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   	Insert Into Inventories(InventoryDate, EmployeeID, ProductID, Count)
    Values (@InventoryDate, @EmployeeID, @ProductID, @Count);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pUpdInventories
Create Procedure pUpdInventories
 (@InventoryID int
 ,@InventoryDate date
 ,@EmployeeID int
 ,@ProductID int
 ,@Count int)
 -- Author: Luis Valderrama
 -- Desc: Update Sproc
 -- Change Log: When,Who,What
 -- 2021-05-23, Luis Valderrama, Created Update Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
     Update Inventories
     Set InventoryDate = @InventoryDate
	   , EmployeeID = @EmployeeID
	   , ProductID = @ProductID
	   , Count = @Count
	 Where InventoryID = @InventoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

--Create Procedure pDelInventories
Create Procedure pDelInventories
 (@InventoryID int)
 -- Author: Luis Valderrama
 -- Desc: Delete Sproc
 -- Change Log: When,Who,What
 -- 2021-05-23, Luis Valderrama, Created Delete Sproc.
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
     Delete
	 From Inventories
     Where InventoryID = @InventoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Question 5 (20 pts): How can you Execute each of your Insert, Update, and Delete stored procedures? 
-- Include custom messages to indicate the status of each sproc's execution.

--< Test Insert Sprocs >--
-- Test [dbo].[pInsCategories]
Declare @Status int;
Declare @LastID int;
Exec @Status = pInsCategories
               @CategoryName = 'A';
Print @Status;
Select Case @Status
  When +1 Then 'Categories Insert was successful!'
  When -1 Then 'Categories Insert failed! Common Issue: Duplicate Data'
  End as [Status];
Select * From vCategories Where CategoryID = Ident_Current('vCategories');
go

-- Test [dbo].[pInsProducts]
Declare @Status int;
Declare @LastID int;
Exec @Status = pInsProducts
               @ProductName = 'A'
			  ,@CategoryID = 1
			  ,@UnitPrice = 9.99;
Print @Status;
Select Case @Status
  When +1 Then 'Products Insert was successful!'
  When -1 Then 'Products Insert failed! Common Issue: Duplicate Data'
  End as [Status];
Select * From vProducts Where ProductID = Ident_Current('vProducts');
go

-- Test [dbo].[pInsEmployees]
Declare @Status int;
Declare @LastID int;
Exec @Status = pInsEmployees
               @EmployeeFirstName = 'Abe'
			  ,@EmployeeLastName = 'Archer'
			  ,@ManagerID = 1;
Print @Status;
Select Case @Status
  When +1 Then 'Employees Insert was successful!'
  When -1 Then 'Employees Insert failed! Common Issue: Duplicate Data'
  End as [Status];
Select * From vEmployees Where EmployeeID = Ident_Current('vEmployees');
go

-- Test [dbo].[pInsInventories]
Declare @Status int;
Declare @LastID int;
Exec @Status = pInsInventories
               @InventoryDate = '20170101'
			  ,@EmployeeID = 1
			  ,@ProductID = 1
			  ,@Count = 42;
Print @Status;
Select Case @Status
  When +1 Then 'Inventories Insert was successful!'
  When -1 Then 'Inventories Insert failed! Common Issue: Duplicate Data'
  End as [Status];
Select * From vInventories Where InventoryID = Ident_Current('vInventories');
go

--< Test Update Sprocs >--
-- Test Update [dbo].[pUpdCategories]
Declare @Status int;
Declare @LastID int;
Set @LastID = Ident_Current('Categories')
Exec @Status = pUpdCategories
                  @CategoryID = @LastID
				 ,@CategoryName = 'B'
Print @Status;
Select Case @Status
  When +1 Then 'Categories Update was successful!'
  When -1 Then 'Categories Update failed!. Common Issue: Duplicate Data'
  End as [Status];
Select * From vCategories Where CategoryID = Ident_Current('vCategories');
go

-- Test [dbo].[pUpdProducts]
Declare @Status int;
Declare @LastID int;
Set @LastID = Ident_Current('Products')
Exec @Status = pUpdProducts
                  @ProductID = @LastID
				 ,@ProductName = 'B'
				 ,@CategoryID = 1
				 ,@UnitPrice = 1.00
Print @Status;
Select Case @Status
  When +1 Then 'Products Update was successful!'
  When -1 Then 'Products Update failed!. Common Issue: Duplicate Data'
  End as [Status];
Select * From vProducts Where ProductID = Ident_Current('vProducts');
go

-- Test [dbo].[pUpdEmployees]
Declare @Status int;
Declare @LastID int;
Set @LastID = Ident_Current('Employees')
Exec @Status = pUpdEmployees
                  @EmployeeID = @LastID
				 ,@EmployeeFirstName = 'Abe'
			     ,@EmployeeLastName = 'Arch'
			     ,@ManagerID = 1;
Print @Status;
Select Case @Status
  When +1 Then 'Employees Update was successful!'
  When -1 Then 'Employees Update failed!. Common Issue: Duplicate Data'
  End as [Status];
Select * From vEmployees Where EmployeeID = Ident_Current('vEmployees');
go

-- Test [dbo].[pUpdInventories]
Declare @Status int;
Declare @LastID int;
Set @LastID = Ident_Current('Inventories')
Exec @Status = pUpdInventories
                  @InventoryID = @LastID
				 ,@InventoryDate = '20170102'
			     ,@EmployeeID = 1
			     ,@ProductID = 1
				 ,@Count = 43;
Print @Status;
Select Case @Status
  When +1 Then 'Inventories Update was successful!'
  When -1 Then 'Inventories Update failed!. Common Issue: Duplicate Data'
  End as [Status];
Select * From vInventories Where InventoryID = Ident_Current('vInventories');
go

--< Test Delete Sprocs >--
-- Test [dbo].[pDelInventories]
Declare @Status int;
Declare @LastID int;
Set @LastID = Ident_Current('Inventories')
Exec @Status = pDelInventories
                  @InventoryID = @LastID		
Print @Status;
Select Case @Status
  When +1 Then 'Inventories Delete was successful!'
  When -1 Then 'Inventories Delete failed!. Common Issue: Duplicate Data'
  End as [Status];
Select * From vInventories Where InventoryID = Ident_Current('vInventories');
go

-- Test [dbo].[pDelEmployees]
Declare @Status int;
Declare @LastID int;
Set @LastID = Ident_Current('Employees')
Exec @Status = pDelEmployees
                  @EmployeeID = @LastID		
Print @Status;
Select Case @Status
  When +1 Then 'Employees Delete was successful!'
  When -1 Then 'Employees Delete failed!. Common Issue: Duplicate Data'
  End as [Status];
Select * From vEmployees Where EmployeeID = Ident_Current('vEmployees');
go

-- Test [dbo].[pDelProducts]
Declare @Status int;
Declare @LastID int;
Set @LastID = Ident_Current('Products')
Exec @Status = pDelProducts
                  @ProductID = @LastID		
Print @Status;
Select Case @Status
  When +1 Then 'Products Delete was successful!'
  When -1 Then 'Products Delete failed!. Common Issue: Duplicate Data'
  End as [Status];
Select * From vProducts Where ProductID = Ident_Current('vProducts');
go

-- Test [dbo].[pDelCategories]
Declare @Status int;
Declare @LastID int;
Set @LastID = Ident_Current('Categories')
Exec @Status = pDelCategories
                  @CategoryID = @LastID		
Print @Status;
Select Case @Status
  When +1 Then 'Categories Delete was successful!'
  When -1 Then 'Categories Delete failed!. Common Issue: Duplicate Data'
  End as [Status];
Select * From vCategories Where CategoryID = Ident_Current('vCategories');
go

-- To Help you, I am providing this template:
/*
Declare @Status int;
Exec @Status = <SprocName>
                @ParameterName = 'A'
Select Case @Status
  When +1 Then '<TableName> Insert was successful!'
  When -1 Then '<TableName> Insert failed! Common Issues: Duplicate Data'
  End as [Status];
Select * From <ViewName> Where ColID = 1;
go
*/

--{ IMPORTANT!!! }--
-- To get full credit, your script must run without having to highlight individual statements!!!  

/***************************************************************************************/