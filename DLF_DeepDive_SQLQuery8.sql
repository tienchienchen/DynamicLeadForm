/*
select * from sysobjects order by crdate desc

select * from sandbox.dbo.proplistDynamicLeadForm 


select YMD=left(a.datekey,4)+'-'+right(left(a.datekey,6),2)+'-'+right(a.datekey,2)
,LeadFormType=a.DLFStatus
,a.EventCount,b.LeadEventCount
from 
  (select  
  DLFStatus=case when pld.listingid is not null then 'DLF'
      else 'No DLF'
      end
  ,datekey
  ,EventCount=count_big(1)
  from fact.webevent_withBadTraffic we
  left join sandbox.dbo.proplistDynamicLeadForm pld
  on we.listingid=cast(pld.listingid as varchar(64))
  where datekey between 20150701 and  20160817 and profilekey=1 and pagesubkey=46 and actionkey=1
  group by
   case when pld.listingid is not null then 'DLF'
      else 'No DLF'
      end
  ,datekey
  ) a
join
  (
  select  
  LeadSubmissionStatus=case when pld.listingid is not null then 'DLF'
      else 'No DLF'
      end
  ,Datekey
  ,LeadEventCount=cast(count_big(1) as decimal)
  from fact.webevent_withBadTraffic we
  left join sandbox.dbo.proplistDynamicLeadForm pld
  on we.listingid=cast(pld.listingid as varchar(64))
  where datekey between 20150701 and  20160817 and profilekey=1 
  and pagesubkey=302
  and actionkey=1
  and positionkey=72
  group by
   case when pld.listingid is not null then 'DLF'
      else 'No DLF'
      end
  ,datekey
      ) b
on a.DLFStatus=b.LeadSubmissionStatus
and a.datekey=b.datekey
order by a.datekey desc , DLFStatus

select * from conformed.pagesub
302	send_button

select * from conformed.pagesub where pagesub='check_availability_button'
46	check_availability_button
--page_sub	check_availability_button
select * from conformed.action
1	click	2016-04-13 17:57:29.210
2	lead_submission	2016-04-13 17:57:29.210
select * from conformed.position
72	lead_submission_form


select *
from openquery(oracleaptg,'select a.ListingID
,a.BedBathLeadsReq
,a.LeadMoveReasonReq
,a.LeadMoveDateReq
,a.LeadMoveDateCalReq
,a.LeadPriceRangeReq
,a.LEADPHONEREQUIRED   
,a.LeadConfirmEmail
,a.TwoNameLeads
,to_number(to_char(a.DynamicLeadFormStart,''yyyymmdd''))  as DynamicLeadFormStartYMDID
,to_number(to_char(a.DynamicLeadFormEnd,''yyyymmdd'')) as DynamicLeadFormEndYMDID
,to_char(a.DynamicLeadFormStart,''mm/dd/yyyy'')  as DynamicLeadFormStartYMD
,to_char(a.DynamicLeadFormEnd,''mm/dd/yyyy'') as DynamicLeadFormEndYMD
FROM Properties.Endeca_Apt60_Listing a
 where to_date(''20160823'',''yyyymmdd'') between a.dynamicLeadFormStart and a.DynamicLeadFormend
 and rownum < 10')


 select *
from openquery(oracleaptg,'select a.ListingID
,a.BedBathLeadsReq
,a.LeadMoveReasonReq
,a.LeadMoveDateReq
,a.LeadMoveDateCalReq
,a.LeadPriceRangeReq
,a.LEADPHONEREQUIRED   
,a.LeadConfirmEmail
,a.TwoNameLeads
,to_number(to_char(a.DynamicLeadFormStart,''yyyymmdd''))  as DynamicLeadFormStartYMDID
,to_number(to_char(a.DynamicLeadFormEnd,''yyyymmdd'')) as DynamicLeadFormEndYMDID
,to_char(a.DynamicLeadFormStart,''mm/dd/yyyy'')  as DynamicLeadFormStartYMD
,to_char(a.DynamicLeadFormEnd,''mm/dd/yyyy'') as DynamicLeadFormEndYMD
FROM Properties.Endeca_Apt60_Listing a
 where trunc(sysdate-1) between a.dynamicLeadFormStart and a.DynamicLeadFormend
 and rownum < 10')


LEADFORMOPTIONID	DESCRIPTION	ISACTIVE	   
1	Beds & Baths	1	   
2	Name	1	   
3	Phone Number	1	   
4	Move-in Date	1	   
5	Price Range	1	   
6	Reason for Moving	1	   
7	Confirm Email Address	1	   
				
LEADFORMOPTIONID	LEADFORMOPTIONVALUEID	   
--1	Beds & Baths
1	1	   
1	2	   
1	3	   bedbathleadsreq
--2	Name
2	4	   
2	5	   (twonameleads)
--3 Phone Number
3	6	   
3	7	   (leadformphonenumberreq)
--4	Move-in Date
4	8	   
4	9	   (leadmovedatereq)
4	10	   
4	11	   
--5	Price Range
5	12	   
5	13	   
5	14	   (leadpricerangereq)
--6	Reason for Moving
6	15	   
6	16	   
6	17	   (leadmovereasonreq)
-- 7	Confirm Email Address
7	18	   
7	19	   (leadconfirmemail)

BedBathLeadsReq,TwoNameLeads,LEADPHONEREQUIRED,	LeadMoveDateReq,LeadMoveDateCalReq,LeadPriceRangeReq,LeadMoveReasonReq,LeadConfirmEmail
(3,5,7,9,11,14,17,19)
                CASE WHEN lfo.phonevalue = 7 THEN 1 ELSE 0 END leadformphonenumberreq,

               CASE WHEN lfo.namevalue = 5 THEN 1 ELSE 0 END twonameleads,

               CASE WHEN lfo.bedbathvalue IN ( 2,3 ) THEN 1 ELSE 0 END bedbathleads,
               CASE WHEN lfo.bedbathvalue IN ( 3 ) THEN 1 ELSE 0 END bedbathleadsreq,

               CASE WHEN lfo.movereasonvalue IN ( 16,17 ) THEN 1 ELSE 0 END leadmovereason,
               CASE WHEN lfo.movereasonvalue IN ( 17 ) THEN 1 ELSE 0 END leadmovereasonreq,

               CASE WHEN lfo.movedatevalue IN ( 8,9 ) THEN 1 ELSE 0 END leadmovedate,
               CASE WHEN lfo.movedatevalue IN ( 9 ) THEN 1 ELSE 0 END leadmovedatereq,

               CASE WHEN lfo.movedatevalue IN ( 10,11 ) THEN 1 ELSE 0 END leadmovedatecal,
               CASE WHEN lfo.movedatevalue IN ( 11 ) THEN 1 ELSE 0 END leadmovedatecalreq,

               CASE WHEN lfo.pricerangevalue IN ( 13,14 ) THEN 1 ELSE 0 END leadpricerange,
               CASE WHEN lfo.pricerangevalue IN ( 14 ) THEN 1 ELSE 0 END leadpricerangereq,

               CASE WHEN lfo.confirmemailvalue IN ( 19 ) THEN 1 ELSE 0 END leadconfirmemail,
               lfo.leadformvalues,
 
 create table dbo.LeadFormOptionValues
 (LEADFORMOPTIONVALUEID int
 ,LEADFORMOPTIONID int
 ,[DESCRIPTION] varchar(150)
 ,ISACTIVE int)
 with (distribution=replicate)

INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 1, 1, 'Do Not Display', 1 ) ;
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 2, 1, 'Display Fields', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 3, 1, 'Display Fields and Require Entry ', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 4, 2, 'Display and Require Full Name Field (one field)', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 5, 2, 'Display and Require First and Last Name Fields (two fields)', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 6, 3, 'Display Phone Number Field', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 7, 3, 'Display and Require Phone Number Entry', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 8, 4, 'Display Move-In Date Estimate Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 9, 4, 'Display and Require Move-In Date Estimate Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 10, 4, 'Display Move-In Date Calendar Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 11, 4, 'Display and Require Move-In Date Calendar Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 12, 5, 'Do Not Display Price Range Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 13, 5, 'Display Price Range Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 14, 5, 'Display and Require Price Range Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 15, 6, 'Do Not Display Reason for Moving Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 16, 6, 'Display Reason for Moving Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 17, 6, 'Display and Require Reason for Moving Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 18, 7, 'Do Not Display Email Confirmation Field', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 19, 7, 'Display and Require Email Confirmation Field', 1 );


 */



 /*
 select * from sysobjects where name like '%dynamic%'


select * 
from ApartmentGuide.Mart.DynamicLeadFormPropValue
where ymdid=20160823 and propertyid =112

--DynamicLeadFormRequiredField from marting
select ymdid,propertyid,ListingID
,case when [3] is null then 0 else 1 end BedBathLeadsReq 
,case when [4] is null then 0 else 1 end FullNameReq 
,case when [5] is null then 0 else 1 end TwoNameLeads
,case when [7] is null then 0 else 1 end LeadPhoneRequired
,case when [9] is null then 0 else 1 end LeadMoveDateReq
,case when [11] is null then 0 else 1 end LeadMoveDateCalReq
,case when [14] is null then 0 else 1 end LeadPriceRangeReq 
,case when [17] is null then 0 else 1 end LeadMoveReasonReq
,case when [19] is null then 0 else 1 end LeadConfirmEmail
from 
(select dl.listingid,dlf.*
   from ApartmentGuide.Mart.DynamicLeadFormPropValue dlf
   join apartmentguide.dimension.listings dl
     on dlf.propertyid=dl.propertyid
  where dlf.ymdid=20160824 --and dlf.leadformoptionValueid in (3,5,7,9,11,14,17,19)
) x
pivot (max(leadFormOptionID) for x.LeadFormOptionValueid in ([3],[4],[5],[7],[9],[11],[14],[17],[19]) ) p



--Listings with required filed on 20160824
select *
from 
(
select ymdid,propertyid,ListingID
,case when [3] is null then 0 else 1 end BedBathLeadsReq 
,case when [4] is null then 0 else 1 end FullNameReq 
,case when [5] is null then 0 else 1 end TwoNameLeads
,case when [7] is null then 0 else 1 end LeadPhoneRequired
,case when [9] is null then 0 else 1 end LeadMoveDateReq
,case when [11] is null then 0 else 1 end LeadMoveDateCalReq
,case when [14] is null then 0 else 1 end LeadPriceRangeReq 
,case when [17] is null then 0 else 1 end LeadMoveReasonReq
,case when [19] is null then 0 else 1 end LeadConfirmEmail
from 
(select dl.listingid,dlf.*
   from ApartmentGuide.Mart.DynamicLeadFormPropValue dlf
   join apartmentguide.dimension.listings dl
     on dlf.propertyid=dl.propertyid
  where dlf.ymdid=20160824 --and dlf.leadformoptionValueid in (3,5,7,9,11,14,17,19)
) x
pivot (max(leadFormOptionID) for x.LeadFormOptionValueid in ([3],[4],[5],[7],[9],[11],[14],[17],[19]) ) p
) v

where LeadMoveDateCalReq > 0
*/

select YMD=left(a.datekey,4)+'-'+right(left(a.datekey,6),2)+'-'+right(a.datekey,2)
,LeadFormType=a.DLFStatus
,a.EventCount,b.LeadEventCount
from 
  (
  select  --*
  DLFStatus=case when pld.listingid is not null then 'DLF'
      else 'No DLF'
      end
  ,datekey
  ,EventCount=count_big(1)
  from fact.webevent_withBadTraffic we
  --left join sandbox.dbo.proplistDynamicLeadForm pld
  left join (select distinct dlf.YMDID, dl.listingID
               from sandbox.dbo.DynamicLeadFormPropValue dlf
               join rentpath.dimension.listings dl
                 on dlf.propertyid=dl.propertyidag
              where dlf.ymdid >= 20160414) pld
  on we.listingid=cast(pld.listingid as varchar(64))
   and we.datekey=pld.ymdid
  where datekey between 20160413 and  20160824 and profilekey=1 and pagesubkey=46 and actionkey=1
  group by
   case when pld.listingid is not null then 'DLF'
      else 'No DLF'
      end
  ,datekey
  ) a
join
  (
  select  
  LeadSubmissionStatus=case when pld.listingid is not null then 'DLF'
      else 'No DLF'
      end
  ,Datekey
  ,LeadEventCount=cast(count_big(1) as decimal)
  from fact.webevent_withBadTraffic we
  --left join sandbox.dbo.proplistDynamicLeadForm pld
  left join (select distinct dlf.YMDID, dl.listingID
               from sandbox.dbo.DynamicLeadFormPropValue dlf
               join rentpath.dimension.listings dl
                 on dlf.propertyid=dl.propertyidag
              where dlf.ymdid >= 20160414) pld
  on we.listingid=cast(pld.listingid as varchar(64)) 
     and we.datekey=pld.ymdid
  where datekey between 20160413 and  20160824 and profilekey=1 
  and pagesubkey=302
  and actionkey=1
  and positionkey=72
  group by
   case when pld.listingid is not null then 'DLF'
      else 'No DLF'
      end
  ,datekey
      ) b
on a.DLFStatus=b.LeadSubmissionStatus
and a.datekey=b.datekey
order by a.datekey desc , DLFStatus
--select * from conformed.pagesub
--302	send_button
--select * from conformed.pagesub where pagesub='check_availability_button'
--46	check_availability_button
--page_sub	check_availability_button
--select * from conformed.action
--1	click	2016-04-13 17:57:29.210
--2	lead_submission	2016-04-13 17:57:29.210
--select * from conformed.position
--72	lead_submission_form
select A.YMD
,BedBathLeadsReqFormOpen,BedBathLeadsReqFormSent, FullNameReqFormOpen,FullNameReqFormSent
  ,LeadMoveReasonReqFormOpen,LeadMoveReasonReqFormSent,LeadMoveDateReqFormOpen,LeadMoveDateReqFormSent
  ,LeadMoveDateCalReqFormOpen,LeadMoveDateCalReqFormSent,LeadPriceRangeReqFormOpen,LeadPriceRangeReqFormSent
  ,LeadPhoneRequiredFormOpen,LeadPhoneRequiredFormSent,LeadConfirmEmailFormOpen,LeadConfirmEmailFormSent
  ,TwoNameLeadsFormOpen,TwoNameLeadsFormSent
from 
(  select  
   YMD=left(datekey,4)+'-'+right(left(datekey,6),2)+'-'+right(datekey,2)
  ,datekey
  ,Events='Check_Availability_Button_Click'
  ,BedBathLeadsReqFormOpen=Sum(BEDBATHLEADSREQ), FullNameReqFormOpen=sum(FullNameReq)
  ,LeadMoveReasonReqFormOpen=sum(LEADMOVEREASONREQ),LeadMoveDateReqFormOpen=sum(LEADMOVEDATEREQ)
  ,LeadMoveDateCalReqFormOpen=sum(LEADMOVEDATECALREQ),LeadPriceRangeReqFormOpen=sum(LEADPRICERANGEREQ)
  ,LeadPhoneRequiredFormOpen=sum(LEADPHONEREQUIRED),LeadConfirmEmailFormOpen=sum(LEADCONFIRMEMAIL)
  ,TwoNameLeadsFormOpen=sum(TWONAMELEADS)
  from apsDimensionalModelweb.fact.webevent_withBadTraffic we
  join
   (select v.*
	 from 
			(
			select ymdid,propertyid,ListingID
			,case when [3] is null then 0 else 1 end BedBathLeadsReq 
			,case when [4] is null then 0 else 1 end FullNameReq 
			,case when [5] is null then 0 else 1 end TwoNameLeads
			,case when [7] is null then 0 else 1 end LeadPhoneRequired
			,case when [9] is null then 0 else 1 end LeadMoveDateReq
			,case when [11] is null then 0 else 1 end LeadMoveDateCalReq
			,case when [14] is null then 0 else 1 end LeadPriceRangeReq 
			,case when [17] is null then 0 else 1 end LeadMoveReasonReq
			,case when [19] is null then 0 else 1 end LeadConfirmEmail
			from 
					(select dl.listingid,dlf.*
					   from ApartmentGuide.Mart.DynamicLeadFormPropValue dlf
					   join apartmentguide.dimension.listings dl
						 on dlf.propertyid=dl.propertyid
					  where dlf.ymdid between 20160701 and  20160824
					) x
			 pivot (max(leadFormOptionID) for x.LeadFormOptionValueid in ([3],[4],[5],[7],[9],[11],[14],[17],[19]) ) p
			) v
     where (v.BEDBATHLEADSREQ+v.FullNameReq+v.LEADMOVEREASONREQ+v.LEADMOVEDATEREQ+v.LEADMOVEDATECALREQ
	        +v.LEADPRICERANGEREQ+v.LEADPHONEREQUIRED+v.LEADCONFIRMEMAIL+v.TWONAMELEADS) > 0
  ) pld
  on we.listingid=cast(pld.listingid as varchar(64))
  and we.datekey=pld.ymdid
  where we.profilekey=1  
    and we.datekey between 20160701 and  20160824
    and we.pagesubkey=46
    and we.actionkey=1
  group by  datekey
) A
join 
(
select  
   YMD=left(datekey,4)+'-'+right(left(datekey,6),2)+'-'+right(datekey,2)
  ,DATEKEY
  ,Events='Click_Lead_Submission_Form_Botton'
  ,BedBathLeadsReqFormSent=Sum(BEDBATHLEADSREQ), FullNameReqFormSent=sum(FullNameReq)
  ,LeadMoveReasonReqFormSent=sum(LEADMOVEREASONREQ),LeadMoveDateReqFormSent=sum(LEADMOVEDATEREQ)
  ,LeadMoveDateCalReqFormSent=sum(LEADMOVEDATECALREQ),LeadPriceRangeReqFormSent=sum(LEADPRICERANGEREQ)
  ,LeadPhoneRequiredFormSent=sum(LEADPHONEREQUIRED),LeadConfirmEmailFormSent=sum(LEADCONFIRMEMAIL)
  ,TwoNameLeadsFormSent=sum(TWONAMELEADS)
  from apsDimensionalModelweb.fact.webevent_withBadTraffic we
  join
   (select *
			from 
			(
			select ymdid,propertyid,ListingID
			,case when [3] is null then 0 else 1 end BedBathLeadsReq 
			,case when [4] is null then 0 else 1 end FullNameReq 
			,case when [5] is null then 0 else 1 end TwoNameLeads
			,case when [7] is null then 0 else 1 end LeadPhoneRequired
			,case when [9] is null then 0 else 1 end LeadMoveDateReq
			,case when [11] is null then 0 else 1 end LeadMoveDateCalReq
			,case when [14] is null then 0 else 1 end LeadPriceRangeReq 
			,case when [17] is null then 0 else 1 end LeadMoveReasonReq
			,case when [19] is null then 0 else 1 end LeadConfirmEmail
			from 
			(select dl.listingid,dlf.*
			   from ApartmentGuide.Mart.DynamicLeadFormPropValue dlf
			   join apartmentguide.dimension.listings dl
				 on dlf.propertyid=dl.propertyid
			  where dlf.ymdid between 20160701 and  20160824
			) x
			pivot (max(leadFormOptionID) for x.LeadFormOptionValueid in ([3],[4],[5],[7],[9],[11],[14],[17],[19]) ) p
			) v
     where (v.BEDBATHLEADSREQ+v.FullNameReq+v.LEADMOVEREASONREQ+v.LEADMOVEDATEREQ+v.LEADMOVEDATECALREQ
	        +v.LEADPRICERANGEREQ+v.LEADPHONEREQUIRED+v.LEADCONFIRMEMAIL+v.TWONAMELEADS) > 0
  ) pld
  on we.listingid=cast(pld.listingid as varchar(64))
  and we.datekey=pld.ymdid
  where we.profilekey=1  
    and we.datekey between 20160701 and  20160824
    and we.pagesubkey=302
    and we.actionkey=1
    and we.positionkey=72
  group by  datekey
  ) B
on a.datekey=b.datekey

##################################################################################
 drop table dbo.LeadFormOptionValues
 create table dbo.LeadFormOptionValues
 (LEADFORMOPTIONVALUEID int
 ,LEADFORMOPTIONID int
 ,[DESCRIPTION] varchar(150)
 ,ISACTIVE int)
 with (distribution=replicate)

INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 1, 1, 'Do Not Display', 1 ) ;
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 2, 1, 'Display Fields', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 3, 1, 'Display Fields and Require Entry ', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 4, 2, 'Display and Require Full Name Field (one field)', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 5, 2, 'Display and Require First and Last Name Fields (two fields)', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 6, 3, 'Display Phone Number Field', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 7, 3, 'Display and Require Phone Number Entry', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 8, 4, 'Display Move-In Date Estimate Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 9, 4, 'Display and Require Move-In Date Estimate Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 10, 4, 'Display Move-In Date Calendar Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 11, 4, 'Display and Require Move-In Date Calendar Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 12, 5, 'Do Not Display Price Range Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 13, 5, 'Display Price Range Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 14, 5, 'Display and Require Price Range Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 15, 6, 'Do Not Display Reason for Moving Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 16, 6, 'Display Reason for Moving Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 17, 6, 'Display and Require Reason for Moving Selection', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 18, 7, 'Do Not Display Email Confirmation Field', 1 );
INSERT INTO dbo.LEADFORMOPTIONVALUES 		 VALUES ( 19, 7, 'Display and Require Email Confirmation Field', 1 );


create table dbo.DynamicLeadFormListingFieldsArray
with (distribution=replicate) as
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
 +case when [8] is not null then '8,' else '' end
 +case when [9] is not null then '9,' else '' end
 +case when [10] is not null then '10,' else ''  end
 +case when [11] is not null then '11,' else '' end
 +case when [12] is not null then '12,' else '' end
 +case when [13] is not null then '13,' else '' end
 +case when [14] is not null then '14,' else '' end
 +case when [15] is not null then '15,' else '' end
 +case when [16] is not null then '16,' else '' end
 +case when [17] is not null then '17,' else '' end
 +case when [18] is not null then '18,' else '' end
 +case when [19] is not null then '19,' else '' end
from
(
select dl.listingid,pv.*  
from dbo.[DynamicLeadFormPropValue] pv
join rentpath.dimension.listings dl on pv.propertyid=dl.propertyidAG
 
where pv.ymdid >=20160901
) s
pivot
(max(leadformoptionid) 
for leadFormOptionValueID in([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19]) 
) p

select * from dynamicleadformListingFieldsarray
select * from DynamicLeadFormTopRank
select * from dbo.leadformoptionvalues
--update dbo.leadformoptionvalues
--set [Description]=[Description]+ ' Beds Baths'
--where leadformOptionid=1

--select * from dbo.LeadFormOptionValues

select dl.listingid, pv.LeadFormOptionValueID, ov.*
from dbo.[DynamicLeadFormPropValue] pv 
join rentpath.dimension.listings dl on pv.propertyid=dl.propertyidAG
join dbo.LeadFormOptionValues ov on pv.LeadFormOptionvalueid=ov.LeadFormoptionvalueid
where pv.ymdid =20160901

--CREATE TABLE [dbo].[DynamicLeadFormPropValue] (
--    [YMDID] int NULL, 
--    [PropertyID] int NULL, 
--    [LeadFormOptionValueID] int NULL, 
--    [LeadFormOptionID] int NULL
--)
--with (distribution = hash(ymdid))
drop table sandbox.dbo.DynamicLeadFormTopRank
create table sandbox.dbo.DynamicLeadFormTopRank
with (distribution=replicate) as
select
RowNum=Row_Number() over (order by count(distinct propertyid) desc) 
,PropertyCount=count(distinct propertyid) 
,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19]
,FormFieldArray=case when [1] =1 then '1,' else '' end
 +case when [2] =2 then '2,' else '' end
 +case when [3] =3 then '3,' else '' end
 +case when [4] =4 then '4,' else '' end
 +case when [5] =5 then '5,' else '' end
 +case when [6] =6 then '6,' else '' end
 +case when [7] =7 then '7,' else '' end
 +case when [8] =8 then '8,' else '' end
 +case when [9] =9 then '9,' else '' end
 +case when [10] =10 then '10,' else ''  end
 +case when [11] =11 then '11,' else '' end
 +case when [12] =12 then '12,' else '' end
 +case when [13] =13 then '13,' else '' end
 +case when [14] =14 then '14,' else '' end
 +case when [15] =15 then '15,' else '' end
 +case when [16] =16 then '16,' else '' end
 +case when [17] =17 then '17,' else '' end
 +case when [18] =18 then '18,' else '' end
 +case when [19] =19 then '19,' else '' end
 ,ArrarySum=[1]+[2]+[3]+[4]+[5]+[6]+[7]+[8]+[9]+[10]+[11]+[12]+[13]+[14]+[15]+[16]+[17]+[18]+[19]
 ,Lable=Case when [1]=1 then  'Do Not Display Beds Baths|'+char(13)+char(10) else '' end 
+Case when [2]=2 then  'Display Fields Beds Baths|'+char(13)+char(10) else '' end 
+Case when [3]=3 then  'Display Fields and Require Entry Beds Baths|'+char(13)+char(10) else '' end 
+Case when [4]=4 then  'Display and Require Full Name Field (one field)|'+char(13)+char(10) else '' end 
+Case when [5]=5 then  'Display and Require First and Last Name Fields (two fields)|'+char(13)+char(10) else '' end 
+Case when [6]=6 then  'Display Phone Number Field|'+char(13)+char(10) else '' end 
+Case when [7]=7 then  'Display and Require Phone Number Entry|'+char(13)+char(10) else '' end 
+Case when [9]=9 then  'Display and Require Move-In Date Estimate Selection|'+char(13)+char(10) else '' end 
+Case when [12]=12 then  'Do Not Display Price Range Selection|'+char(13)+char(10) else '' end 
+Case when [13]=13 then  'Display Price Range Selection|'+char(13)+char(10) else '' end 
+Case when [14]=14 then  'Display and Require Price Range Selection|'+char(13)+char(10) else '' end 
+Case when [15]=15 then  'Do Not Display Reason for Moving Selection|'+char(13)+char(10) else '' end 
+Case when [16]=16 then  'Display Reason for Moving Selection|'+char(13)+char(10) else '' end 
+Case when [17]=17 then  'Display and Require Reason for Moving Selection|'+char(13)+char(10) else '' end 
+Case when [8]=8 then  'Display Move-In Date Estimate Selection|'+char(13)+char(10) else '' end 
+Case when [11]=11 then  'Display and Require Move-In Date Calendar Selection|'+char(13)+char(10) else '' end 
+Case when [19]=19 then  'Display and Require Email Confirmation Field|'+char(13)+char(10) else '' end 
+Case when [10]=10 then  'Display Move-In Date Calendar Selection|'+char(13)+char(10) else '' end 
+Case when [18]=18 then  'Do Not Display Email Confirmation Field|'+char(13)+char(10) else '' end 
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
 ,[8] =case when [8] is not null then 8 else 0 end
 ,[9] =case when [9] is not null then 9 else 0 end
 ,[10] =case when [10] is not null then 10 else 0 end
 ,[11] =case when [11] is not null then 11 else 0 end
 ,[12] =case when [12] is not null then 12 else 0 end
 ,[13] =case when [13] is not null then 13 else 0 end
 ,[14] =case when [14] is not null then 14 else 0 end
 ,[15] =case when [15] is not null then 15 else 0 end
 ,[16] =case when [16] is not null then 16 else 0 end
 ,[17] =case when [17] is not null then 17 else 0 end
 ,[18] =case when [18] is not null then 18 else 0 end
 ,[19] =case when [19] is not null then 19 else 0 end
from
(
select *  from dbo.[DynamicLeadFormPropValue] where ymdid=20160901
) s
pivot
(max(leadformoptionid) 
for leadFormOptionValueID in([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19]) 
) p
) v
group by [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19]

select * from sandbox.dbo.dynamicLeadformtoprank order by propertyCount desc
select '+Case when ['+Cast(leadformOptionValueID as varchar(10))+']='+Cast(leadformOptionValueID as varchar(10))++' then  '''+ Description + ''' else '''' end '
from leadformOptionvalues
select * from 

--drop table dbo.dynamicLeadformPropValue

-- truncate table sandbox.dbo.DynamicLeadFormPropValue


-- drop table dbo.LeadFormOptionValues
-- create table dbo.LeadFormOptionValues
-- (LEADFORMOPTIONVALUEID int
-- ,LEADFORMOPTIONID int
-- ,[DESCRIPTION] varchar(150)
-- ,ISACTIVE int)
-- with (distribution=replicate)

Create table dbo.DynamicLeadFormListingRank 

with (distribution=hash(listingID))

as
   select la.listingID, tr.*
  from dbo.DynamicLeadFormListingFieldsArray la
  join DynamicLeadFormTopRank tr on la.FormFieldArray=tr.FormFieldArray
  order by RowNum

 --##########################################################
--Final Result
--###########################################################
select A.*
,FormSent=case when B.formSent is null then 0 else b.FormSent end 
from 
(  select  
   YMD=left(datekey,4)+'-'+right(left(datekey,6),2)+'-'+right(datekey,2)
  ,datekey
  ,Events='Check_Availability_Button_Click'
  ,FormFieldArray,Lable
  ,RowNum
  ,FormOpen=count_big(distinct we.WebEventKey)
  from DimensionalModelweb.fact.webevent we
  join DynamicLeadFormListingRank pld
  on we.listingid=cast(pld.listingid as varchar(64))
  where we.profilekey=1  
    and we.datekey between 20160414 and  20160831
    and we.pagesubkey in (46,68,80)
    and we.actionkey=1
  group by  datekey,FormFieldArray,Lable,RowNum
) A
left join 
(
select  
   YMD=left(datekey,4)+'-'+right(left(datekey,6),2)+'-'+right(datekey,2)
  ,DATEKEY
  ,Events='Click_Lead_Submission_Form_Botton'
  ,FormFieldArray,Lable
  ,RowNum
  ,FormSent=count_big(distinct we.WebEventKey)
  from DimensionalModelweb.fact.webevent we
  join DynamicLeadFormListingRank pld
  on we.listingid=cast(pld.listingid as varchar(64))
  where we.profilekey=1  
    and we.datekey between 20160414 and  20160831
    and we.pagesubkey=302
    and we.actionkey=1
    and we.positionkey=72
  group by  datekey,FormFieldArray,Lable,RowNum
  ) B
on a.datekey=b.datekey and a.FormFieldArray=b.formFieldArray
order by a.rownum
