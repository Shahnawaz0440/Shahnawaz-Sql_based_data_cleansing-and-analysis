/*
Cleaning data in Sql queries
*/

Select *
From portfolioproject.dbo.nationalhousing

--Standardlize date format

Select SaleDateConverted, CONVERT(Date, SaleDate)
From portfolioproject.dbo.nationalhousing

update nationalhousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE nationalhousing
ADD SaleDateConverted Date

update nationalhousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--------------------------------------------------------------------------------------------------------------

--Populate property Address date

Select* --PropertyAddress
From portfolioproject.dbo.nationalhousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From portfolioproject.dbo.nationalhousing a
JOIN portfolioproject.dbo.nationalhousing b 
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is  null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From portfolioproject.dbo.nationalhousing a
JOIN portfolioproject.dbo.nationalhousing b 
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

--breaking out addres  into individual columns (Adress, city,Sate)

Select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)as Address
--CHARINDEX(',', PropertyAddress)as Address
From portfolioproject.dbo.nationalhousing
--Where PropertyAddress is null
--order by ParcelID

Select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 ,LEN(PropertyAddress))as Address
From portfolioproject.dbo.nationalhousing

ALTER TABLE nationalhousing
ADD PropertySplitiAddress NvarChar(255);

update nationalhousing
SET PropertySplitiAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE nationalhousing
ADD PropertySplitCity NvarChar(255);

update nationalhousing
SET PropertySplitCity =SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 ,LEN(PropertyAddress))

Select *
From portfolioproject.dbo.nationalhousing





Select OwnerAddress
From portfolioproject.dbo.nationalhousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From portfolioproject.dbo.nationalhousing
 
 ALTER TABLE nationalhousing
ADD OwnerSplitiAddress NvarChar(255);

update nationalhousing
SET OwnerSplitiAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE nationalhousing
ADD OwnerSplitCity NvarChar(255);

update nationalhousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE nationalhousing
ADD OwnerSplitState NvarChar(255);

update nationalhousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select *
From portfolioproject.dbo.nationalhousing

ALTER TABLE nationalhousing
DROP COLUMN OwnerSplitSate


Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From portfolioproject.dbo.nationalhousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant,
CASE When SoldAsVacant = 'Y'THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From portfolioproject.dbo.nationalhousing


update nationalhousing
SET SoldAsVacant  = CASE When SoldAsVacant = 'Y'THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END


	 --------------------------------------------------------------------------

	 --Remove duplicates
	 WITH RowNumCTE as(
	 Select *,
	 ROW_NUMBER() OVER(
	 PARTITION BY ParcelId,
				  PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  order by
				  UniqueID
				  )row_num
     From portfolioproject.dbo.nationalhousing
	 )
	  Select *
	 From RowNumCTE
	 where row_num >1
	 --order by PropertyAddress


	 Select *
	 From portfolioproject.dbo.nationalhousing
	 --order by ParcelID
	 

