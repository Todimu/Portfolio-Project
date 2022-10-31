Select *
From PortfolioProject.dbo.[Nashville Housing Project]


-- Standardize Sale Date
Select SaleDate, Convert(Date, SaleDate)
From PortfolioProject.dbo.[Nashville Housing Project]

Update [Nashville Housing Project]
SET SaleDate = Convert(Date, SaleDate)


-- Populate  Property Address Data
Select *
From PortfolioProject.dbo.[Nashville Housing Project]
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.[Nashville Housing Project] a
Join PortfolioProject.dbo.[Nashville Housing Project] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.[Nashville Housing Project] a
Join PortfolioProject.dbo.[Nashville Housing Project] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] != b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking out Address Into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.[Nashville Housing Project]


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.[Nashville Housing Project]

Alter Table [Nashville Housing Project]
Add PropertySplitAddress Nvarchar (255);

Update [Nashville Housing Project]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)



Alter Table PortfolioProject.dbo.[Nashville Housing Project]
Add PropertySplitCity Nvarchar (255);

Update [Nashville Housing Project]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



Select *
From PortfolioProject.dbo.[Nashville Housing Project]






Select OwnerAddress
From PortfolioProject.dbo.[Nashville Housing Project]


Select PARSENAME(Replace(OwnerAddress, ',', '.'), 3)
,PARSENAME(Replace(OwnerAddress, ',', '.'), 2)
,PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From PortfolioProject.dbo.[Nashville Housing Project]

Alter Table PortfolioProject.dbo.[Nashville Housing Project]
Add OwnerSplitAddress Nvarchar (255);

Update PortfolioProject.dbo.[Nashville Housing Project]
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)


Alter Table PortfolioProject.dbo.[Nashville Housing Project]
Add OwnerSplitCity Nvarchar (255);

Update PortfolioProject.dbo.[Nashville Housing Project]
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)


Alter Table PortfolioProject.dbo.[Nashville Housing Project]
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.[Nashville Housing Project]
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)


Select *
From PortfolioProject.dbo.[Nashville Housing Project]





Select Distinct (SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.[Nashville Housing Project]
Group by SoldAsVacant
Order by 2





Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' then 'Yes'
		When SoldAsVacant = 'N' then 'No'
		ELSE SoldAsVacant
		END
From PortfolioProject.dbo.[Nashville Housing Project]

Update PortfolioProject.dbo.[Nashville Housing Project]
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' then 'Yes'
		When SoldAsVacant = 'N' then 'No'
		ELSE SoldAsVacant
		END


		

--Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.[Nashville Housing Project]
)
Select *
--DELETE
FROM RowNumCTE
where row_num > 1
--ORDER BY  PropertyAddress


----------------------------------------------------------
-- DELETE Unused Columns

Select*
From PortfolioProject.dbo.[Nashville Housing Project]

ALTER TABLE PortfolioProject.dbo.[Nashville Housing Project]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.[Nashville Housing Project]
DROP COLUMN SaleDate