 Select * 
 From PortfoliioProject.dbo.NashvilleHousing;

 -- Standardize Date Format

 Select SaleDateConverted, CONVERT(Date, Saledate)
 From PortfoliioProject.dbo.NashvilleHousing;

 UPDATE PortfoliioProject.dbo.NashvilleHousing
 SET SaleDate = CONVERT(Date, Saledate)

 ALTER TABLE PortfoliioProject.dbo.NashvilleHousing
 Add SaleDateConverted Date;
 
 
 UPDATE PortfoliioProject.dbo.NashvilleHousing
 SET SaledateConverted = CONVERT(Date, Saledate)


 -- Populate Poperty Address data


 Select *
 From PortfoliioProject.dbo.NashvilleHousing
 --WHERE PropertyAddress is null;

 Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
 From PortfoliioProject.dbo.NashvilleHousing a
 JOIN PortfoliioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfoliioProject.dbo.NashvilleHousing a
 JOIN PortfoliioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null


--Breaking out Address into Individual Columns(Address, City, State)


 Select PropertyAddress
 From PortfoliioProject.dbo.NashvilleHousing

 SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfoliioProject.dbo.NashvilleHousing

 ALTER TABLE PortfoliioProject.dbo.NashvilleHousing
 Add PropertySplitAddress Nvarchar(255);
 
 
 UPDATE PortfoliioProject.dbo.NashvilleHousing
 SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 
 
 
 ALTER TABLE PortfoliioProject.dbo.NashvilleHousing
 Add PropertySplitCity Nvarchar(255);
 
 
 UPDATE PortfoliioProject.dbo.NashvilleHousing
 SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


 SELECT *
 From PortfoliioProject.dbo.NashvilleHousing


 -- Change Y and N to Yes and No in 'Sold as Vacant' feild


 Select Distinct(SoldAsVacant), Count(SoldAsVacant)
  From PortfoliioProject.dbo.NashvilleHousing
  Group by SoldAsVacant
  Order by 2

  Select SoldAsVacant
  ,Case When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		End
  From PortfoliioProject.dbo.NashvilleHousing


Update PortfoliioProject.dbo.NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		End

-- Remove Dulpicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER  BY 
					UniqueID
					) row_num
From PortfoliioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
Delete
From RowNumCTE
Where row_num > 1


--Delete Unused Columns

Select *
From PortfoliioProject.dbo.NashvilleHousing


ALTER TABLE PortfoliioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

