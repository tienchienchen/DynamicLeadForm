1)  Create mdot temp table in warehouse
--create table dbo.DynamicLeadFormListingFieldsArray
--with (distribution=replicate) as
drop table sandbox.dbo.DynamicLeadFormListingFieldArray
select 
 distinct 
 listingid
 ,propertyid
 ,FormFieldArray=case when [1] is not null then '1,' else '' end
 +case when [2] is not null then '2,' else '' end
 +case when [3] is not null then '3,' else '' end
 +case when [4] is not null then '4,' else '' end
 +case when [5] is not null then '5,' else '' end
 +case when [6] is not null then '6,' else '' end
 +case when [7] is not null then '7,' else '' end
 into sandbox.dbo.mDynamicLeadFormListingFieldArray
from
(
select dl.listingid,pv.*  
from apartmentguide.mart.[DynamicLeadFormPropValue] pv
join rentpath.dimension.listings dl on pv.propertyid=dl.propertyidAG
 
where pv.ymdid >=20160901
) s
pivot
(max(leadformoptionid) 
for leadFormOptionValueID in([1],[2],[3],[4],[5],[6],[7]) 
) p

2) create table for mdot top rank combination
select
RowNum=Row_Number() over (order by count(distinct propertyid) desc) 
,PropertyCount=count(distinct propertyid) 
,[1],[2],[3],[4],[5],[6],[7]
,FormFieldArray=case when [1] =1 then '1,' else '' end
 +case when [2] =2 then '2,' else '' end
 +case when [3] =3 then '3,' else '' end
 +case when [4] =4 then '4,' else '' end
 +case when [5] =5 then '5,' else '' end
 +case when [6] =6 then '6,' else '' end
 +case when [7] =7 then '7,' else '' end
 ,ArrarySum=[1]+[2]+[3]+[4]+[5]+[6]+[7]
 ,Lable=Case when [1]=1 then  'Do Not Display Beds Baths|' else '' end 
+Case when [2]=2 then  'Display Fields Beds Baths|' else '' end 
+Case when [3]=3 then  'Display Fields and Require Entry  Beds Baths|' else '' end 
+Case when [4]=4 then  'Display and Require Full Name Field (one field)|' else '' end 
+Case when [5]=5 then  'Display and Require First and Last Name Fields (two fields)|' else '' end 
+Case when [6]=6 then  'Display Phone Number Field|' else '' end 
+Case when [7]=7 then  'Display and Require Phone Number Entry|' else '' end 
into sandbox.dbo.mDynamicLeadFormTopRank
from 
(
select 
 ymdid, propertyid
 ,[1] =case when [1] is not null then 1 else 0 end
 ,[2] =case when [2] is not null then 2 else 0 end
 ,[3] =case when [3] is not null then 3 else 0 end
 ,[4] =case when [4] is not null then 4 else 0 end
 ,[5] =case when [5] is not null then 5 else 0 end
 ,[6] =case when [6] is not null then 6 else 0 end
 ,[7] =case when [7] is not null then 7 else 0 end
from
(
select *  from apartmentguide.mart.[DynamicLeadFormPropValue] where ymdid=20160901
) s
pivot
(max(leadformoptionid) 
for leadFormOptionValueID in([1],[2],[3],[4],[5],[6],[7]) 
) p
) v
group by [1],[2],[3],[4],[5],[6],[7]

select * from sandbox.dbo.mDynamicLeadFormTopRank

3)
--Create table sandbox.dbo.mDynamicLeadFormListingRank 
--as
   select la.listingID, tr.*
   into sandbox.dbo.mDynamicLeadFormListingRank 
  from sandbox.dbo.mDynamicLeadFormListingFieldArray la
  join sandbox.dbo.mDynamicLeadFormTopRank tr on la.FormFieldArray=tr.FormFieldArray

4) Upload  sandbox.dbo.mDynamicLeadFormListingRank from warehouse to APS

select  * from sandbox.dbo.mDynamicLeadFormListingRank


 5) 
  select 
A.YMD,A.datekey,A.[Events],A.FormFieldArray,A.Lable,A.RowNum
,FormOpen = case when a.formOpen is null then 0 else a.formOpen end
,FormSent = case when B.formSent is null then 0 else b.FormSent end 
,FormOpenListingCount
,FormSentListingCount=case when B.FormSentListingCount is null then 0 else b.FormSentListingCount end
from 
(  select  
   YMD=left(datekey,4)+'-'+right(left(datekey,6),2)+'-'+right(datekey,2)
  ,datekey
  ,Events='Check_Availability_Button_Click'
  ,FormFieldArray= case when FormFieldArray is null then 'Default' else FormFieldArray end
  ,Lable= case when Lable is null then 'Default' else Lable end
  ,RowNum= case when Lable is null then 0 else RowNum end
  ,FormOpen=count_big(distinct we.WebEventKey)
  ,FormOpenListingCount=count(distinct we.listingid)
  from DimensionalModelweb.fact.webevent we
  left join DynamicLeadFormListingRank pld
  on we.listingid=cast(pld.listingid as varchar(64))
where we.datekey between 20160602 and  20160913
  and profilekey=2 
  and we.listingid <>''
  and pagekey=53
  and pagesubkey =46 
  and positionkey=42
  and isnumeric(we.listingid)=1
  and (cast(we.listingid as int ) < 2000000 or cast(we.listingid as int )> 100000000 )  
group by  datekey,FormFieldArray,Lable,RowNum
) A
left join 
(
select  
   YMD=left(datekey,4)+'-'+right(left(datekey,6),2)+'-'+right(datekey,2)
  ,DATEKEY
  ,Events='Click_Lead_Submission_Form_Botton'
  ,FormFieldArray= case when FormFieldArray is null then 'Default' else FormFieldArray end
  ,Lable= case when Lable is null then 'Default' else Lable end
  ,RowNum= case when Lable is null then 0 else RowNum end
  ,FormSent=count_big(distinct we.WebEventKey)
  ,FormSentListingCount= count_big(distinct we.listingid)
  from DimensionalModelweb.fact.webevent we
  left join DynamicLeadFormListingRank pld
  on we.listingid=cast(pld.listingid as varchar(64))
 where  we.datekey between 20160602 and  20160913
   and profilekey=2   --mdot
  and pagekey=53
  and pagesubkey=302 -- send_button
  and positionkey=72  --lead_submission_form
  and we.listingid <>''
  and isnumeric(we.listingid)=1
  and (cast(we.listingid as int ) < 2000000 or cast(we.listingid as int )> 100000000 ) 
  group by  datekey,FormFieldArray,Lable,RowNum
  ) B
on a.datekey=b.datekey and a.FormFieldArray=b.formFieldArray
order by a.rownum,a.datekey

