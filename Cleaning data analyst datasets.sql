--Fixing name Column1 to ID
EXEC sp_rename 'Dataanalyst..DataAnalyst$.Column1', 'Id';
 

--replaceing -1 with null
update DataAnalyst..DataAnalyst$
set [Salary Estimate] = null
where [Salary Estimate] = '-1'

update DataAnalyst..DataAnalyst$
set Rating = null
where Rating = '-1'

update DataAnalyst..DataAnalyst$
set Headquarters = null
where Headquarters = '-1'

update DataAnalyst..DataAnalyst$
set Size = null
where Size = '-1'

update DataAnalyst..DataAnalyst$
set Founded = null
where Founded = '-1'

update DataAnalyst..DataAnalyst$
set [Type of ownership] = null
where [Type of ownership] = '-1'

update DataAnalyst..DataAnalyst$
set Industry = null
where Industry = '-1'

update DataAnalyst..DataAnalyst$
set Sector = null
where Sector = '-1'

update DataAnalyst..DataAnalyst$
set Revenue = null
where Revenue = '-1'

update DataAnalyst..DataAnalyst$
set Competitors = null
where Competitors = '-1'

update DataAnalyst..DataAnalyst$
set [Easy Apply] = null
where [Easy Apply] = '-1'


--Spliting Location column in to City and state
alter table DataAnalyst..DataAnalyst$
add City varchar(255), State varchar(255)

select Location, 
PARSENAME(Replace(Location,',','.'),2) as City,
PARSENAME(Replace(Location,',','.'),1) as State
from DataAnalyst..DataAnalyst$ 

update DataAnalyst..DataAnalyst$
set City = PARSENAME(Replace(Location,',','.'),2) 
from DataAnalyst..DataAnalyst$ 

update DataAnalyst..DataAnalyst$
set State = PARSENAME(Replace(Location,',','.'),1) 
from DataAnalyst..DataAnalyst$ 

--Spliting Headquaters column in to Headquater_City and Headquater_state
alter table DataAnalyst..DataAnalyst$
add Headquarters_City varchar(255), Headquarters_State varchar(255)

select Headquarters, 
PARSENAME(Replace(Headquarters,',','.'),2) as Headquarters_City,
PARSENAME(Replace(Headquarters,',','.'),1) as Headquarters_State
from DataAnalyst..DataAnalyst$ 

update DataAnalyst..DataAnalyst$
set Headquarters_City = PARSENAME(Replace(Headquarters,',','.'),2) 
from DataAnalyst..DataAnalyst$ 

update DataAnalyst..DataAnalyst$
set Headquarters_State = PARSENAME(Replace(Headquarters,',','.'),1) 
from DataAnalyst..DataAnalyst$ 

-- Triming Salary estimate
select trim('(Glassdoor est.)' from [Salary Estimate]), [Salary Estimate]
from DataAnalyst..DataAnalyst$ 

update DataAnalyst..DataAnalyst$
set [Salary Estimate] = trim('(Glassdoor est.)' from [Salary Estimate])

--Fixing name Size to Company_Size
EXEC sp_rename 'DataAnalyst$.Size', 'Company_Size'; 

--Fixing Company_Size data 
update DataAnalyst..DataAnalyst$
set Company_Size = case
	when Company_Size = '1 to 50 employees' then '50 Employee'
	when Company_Size = '51 to 200 employees' then '50+ Employee'
	when Company_Size = '201 to 500 employees' then '200+ Employee'
	when Company_Size = '501 to 1000 employees' then '500+ Employee'
	when Company_Size = '1001 to 5000 employees' then '1000+ Employee' 
	when Company_Size = '5001 to 10000 employees' then '5000+ Employee' 
	when Company_Size = '10000+ employees' then '10000+ Employee' 
end  
from DataAnalyst..DataAnalyst$ 

--Fixing Revenue data 
alter table DataAnalyst..DataAnalyst$  
add new_revenue varchar(255)

update DataAnalyst..DataAnalyst$
set new_revenue =
 case
	when Revenue = '$10 to $25 million (USD)' then 25000000
	when Revenue = '$25 to $50 million (USD)' then 50000000  
	when Revenue = '$50 to $100 million (USD)' then 100000000 
	when Revenue = '$100 to $500 million (USD)' then 500000000   
	when Revenue = '$500 million to $1 billion (USD)' then 1000000000 
	when Revenue = '$1 to $2 billion (USD)' then 2000000000  
	when Revenue = '$2 to $5 billion (USD)' then 5000000000  
	when Revenue = '$5 to $10 billion (USD)' then 10000000000 
end
from DataAnalyst..DataAnalyst$ 

EXEC sp_rename 'DataAnalyst$.new_revenue', 'New_Revenue'; 

--Fixing Easy apply column
update DataAnalyst..DataAnalyst$ 
set [Easy Apply] = 'False'
where [Easy Apply] is null

-- Delete unwanted Columns
alter table DataAnalyst..DataAnalyst$
drop column Location, Headquarters, [job Description], Revenue_fixed, Revenue

-- Show all record
select *
from DataAnalyst..DataAnalyst$
order by id