-- select * from NashvilleHousing order by parcelID


--** Standardize Dateformat

Select SaleDate, CONVERT(date,SaleDate)
from NashvilleHousing


select * from NashvilleHousing

alter table  NashvilleHousing
add SaleDateConverted date

update NashvilleHousing
set SaleDateConverted = CONVERT(date,SaleDate)


--** populate property Address data

select  a.ParcelID,a.propertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.propertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID and a.[UniqueID ]<> b.[UniqueID ]
where a.propertyAddress is null



update a
set PropertyAddress = ISNULL(a.propertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID and a.[UniqueID ]<> b.[UniqueID ]
where a.propertyAddress is null



--** Breaking Property addresss into individual columns(Address,City,State) using SUBSTRING

select PropertyAddress
from NashvilleHousing 
 
select SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1) as  Address,
	SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1, Len(PropertyAddress)) as City
from NashvilleHousing



Alter table nashvillehousing
add PropertySplitAddress nvarchar(255)

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1)




Alter table nashvillehousing
add PropertySplitCity nvarchar(255)

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1, Len(PropertyAddress))



--** Update Owner address  into individual columns(Address,City,State) using PARSENAME (it always works for '.' therefore need to replace ',' with '.')

select * from NashvilleHousing


select PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from NashvilleHousing


Alter table nashvillehousing
add OwnerSplitAddress nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)


Alter table nashvillehousing
add OwnerSplitCity nvarchar(255)

update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)


Alter table nashvillehousing
add OwnerSplitState nvarchar(255)

update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)


 --** Change Y and N to Yes and No in 'Sold as vacant' field
 
 select distinct(SoldAsVacant) from NashvilleHousing

 --begin tran 

 select SoldAsVacant, REPLACE(SoldAsvacant,'Y','Yes') 
 from  NashvilleHousing
 where SoldAsvacant = 'Y'

 update NashvilleHousing
 set SoldAsVacant = REPLACE(SoldAsvacant,'Y','Yes') 
 where SoldAsvacant = 'Y'


  select SoldAsVacant, REPLACE(SoldAsvacant,'N','No') 
 from  NashvilleHousing
 where SoldAsvacant = 'N'

 update NashvilleHousing
 set SoldAsVacant = REPLACE(SoldAsvacant,'N','No')
 where SoldAsvacant = 'N'

 --commit

 -- METHOD 2 :- using CASE statment
 select SoldAsVacant,
 CASE when SoldAsVacant ='Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
 END
 from NashvilleHousing

 -- To Verify

 select distinct(SoldAsVacant), count(SoldAsVacant)
 from NashvilleHousing
 group by SoldAsVacant



 
 -- ** Remove Duplicates Using CTE & Window Funcitions (Never use on RAW data )
 select  * from NashvilleHousing


 with rownumCTE as(
 select *,
	ROW_NUMBER() over(partition by parcelID, propertyAddress, Saleprice, SaleDate, legalreference order by UniqueID) row_num  
 from NashvilleHousing
 )
 -- delete the records whose row_num is 2 or greater (total 104 rows deleted)
delete from rownumCTE
 where row_num > 1
 


 -- ** delete Unused Columns (Never use on RAW data ) -- Delete ownerAddress, propertyAddress, TaxDistrict, SaleDate

 select * from NashvilleHousing

 alter table NashvilleHousing
 drop column Owneraddress, taxDistrict, propertyAddress,SaleDate