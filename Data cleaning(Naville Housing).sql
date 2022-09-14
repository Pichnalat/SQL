
Select *
From PortfolioProject.dbo.NashvilleHousingDataCleaning


--Standardize date format
Select Saledate, CONVERT(Date,Saledate)
From PortfolioProject.dbo.NashvilleHousingDataCleaning

Alter table NashvilleHousingDataCleaning
Add SaleDateConverted Date;

Update NashvilleHousingDataCleaning
SET SaleDateConverted = CONVERT(date,Saledate)



--Populate Property Address date
Select *
from PortfolioProject.dbo.NashvilleHousingDataCleaning
where PropertyAddress is null
order by parcelID

Select a.parcelID, a.PropertyAddress,b.parcelID, b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress) 
From PortfolioProject.dbo.NashvilleHousingDataCleaning a
join PortfolioProject.dbo.NashvilleHousingDataCleaning b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousingDataCleaning a
join PortfolioProject.dbo.NashvilleHousingDataCleaning b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


--Breaking out PropertyAddress into Individuak Columns (Address, City, State)
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousingDataCleaning
--where PropertyAddress is null
--order by parcelID


Select
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) As Address
,substring(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress)) As Address
From PortfolioProject.dbo.NashvilleHousingDataCleaning

ALTER TABLE NashvilleHousingDataCleaning
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousingDataCleaning
SET PropertySplitAddress  = SUBSTRING( PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1 ) 

ALTER TABLE PortfolioProject.dbo.NashvilleHousingDataCleaning
Add PropertySplitCity  Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousingDataCleaning 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


--Breaking out OwnerAddress into Individual Columns (Address, City, State)

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousingDataCleaning

Select 
parsename(replace(OwnerAddress, ',','.'),3)
,parsename(replace(OwnerAddress, ',','.'),2)
,parsename(replace(OwnerAddress, ',','.'),1)
From PortfolioProject.dbo.NashvilleHousingDataCleaning

ALTER TABLE PortfolioProject.dbo.NashvilleHousingDataCleaning
Add OwnerSplitAddress  Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousingDataCleaning 
SET OwnerSplitAddress = parsename(replace(OwnerAddress, ',','.'),3)

ALTER TABLE PortfolioProject.dbo.NashvilleHousingDataCleaning
Add OwnerSplitCity  Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousingDataCleaning 
SET OwnerSplitCity = parsename(replace(OwnerAddress, ',','.'),2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousingDataCleaning
Add OwnerSplitState  Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousingDataCleaning 
SET OwnerSplitState = parsename(replace(OwnerAddress, ',','.'),1)

--Change Y and N to Yes and NO in "Sold as Vacant" field

Select
distinct(SoldasVacant),Count(SoldasVacant)
From PortfolioProject.dbo.NashvilleHousingDataCleaning
Group by SoldasVacant


Select SoldasVacant
,CASE WHEN SoldasVacant = 'Y' then 'Yes'
	  WHEN SoldasVacant = 'N' then 'no'
	  ELSE SoldasVacant
	  END
From PortfolioProject.dbo.NashvilleHousingDataCleaning

UPDATE NashvilleHousingDataCleaning
SET SoldasVacant = CASE 
	WHEN SoldasVacant = 'Y' then 'Yes'
	WHEN SoldasVacant = 'N' then 'No'
	ELSE SoldasVacant
	END


--Remove duplicate

with RowNumCTE AS (
Select
*,
ROW_NUMBER() over ( partition by ParcelID,PropertyAddress  ,SalePrice,SaleDate,LegalReference

order by UniqueID ) AS row_num
From PortfolioProject.dbo.NashvilleHousingDataCleaning
--order by ParcelID
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



with RowNumCTE AS (
Select
*,
ROW_NUMBER() over ( partition by ParcelID,PropertyAddress  ,SalePrice,SaleDate,LegalReference

order by UniqueID ) AS row_num
From PortfolioProject.dbo.NashvilleHousingDataCleaning
--order by ParcelID
)

Delete
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

--Delete Unused Columns
Select *
From PortfolioProject.dbo.NashvilleHousing

Alter table PortfolioProject.dbo.NashvilleHousingDataCleaning
Drop column OwnerAddress,PropertyAddress,SaleDate



