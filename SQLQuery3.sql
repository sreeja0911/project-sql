Select *
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Populate Property Address data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-------------------------------------------------------------------
--Breaking out address into individual columns (address,city,state)
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

select
substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,charindex(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET  PropertySplitAddress= substring(PropertyAddress,1,charindex(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET  PropertySplitCity= substring(PropertyAddress,charindex(',',PropertyAddress)+1,LEN(PropertyAddress))

select *
from PortfolioProject..NashvilleHousing

select OwnerAddress
from PortfolioProject..NashvilleHousing

SELECT
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET  OwnerSplitAddress= PARSENAME(Replace(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET  OwnerSplitCity= PARSENAME(Replace(OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET  OwnerSplitState= PARSENAME(Replace(OwnerAddress,',','.'),1)

select *
from PortfolioProject..NashvilleHousing

----------------------------------------------------------------------

select distinct(SoldAsVacant), count(soldasvacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant, 
CASE WHEN SoldAsVacant='Y' then 'Yes'
	 WHEN SoldAsVacant='N' then 'No'
	 ELSE SoldAsVacant
	 END
from PortfolioProject..NashvilleHousing


Update NashvilleHousing
SET  SoldAsVacant=
CASE WHEN SoldAsVacant='Y' then 'Yes'
	 WHEN SoldAsVacant='N' then 'No'
	 ELSE SoldAsVacant
	 END
from PortfolioProject..NashvilleHousing

---------------------------------------------------------------
--REMOVE DUPLICATES

with RowNumCTE AS(
select *,row_number() over( Partition by ParcelID,
										PropertyAddress,
										SalePrice, 
										LegalReference
										ORDER BY
										UniqueID
										)row_num

from PortfolioProject..NashvilleHousing
)
DELETE
from RowNumCTE
where row_num>1

------------------------------------------------------------------------
--Delete unused columns

ALTER TABLE PortfolioProject..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress


select *
from PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
drop column SaleDate