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
  from apsDimensionalModelweb.fact.webevent we
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
       where dlf.ymdid between 20160701 and  20160912
     ) x
    pivot (max(leadFormOptionID) for x.LeadFormOptionValueid in ([3],[4],[5],[7],[9],[11],[14],[17],[19]) ) p
   ) v
     where (v.BEDBATHLEADSREQ+v.FullNameReq+v.LEADMOVEREASONREQ+v.LEADMOVEDATEREQ+v.LEADMOVEDATECALREQ
         +v.LEADPRICERANGEREQ+v.LEADPHONEREQUIRED+v.LEADCONFIRMEMAIL+v.TWONAMELEADS) > 0
  ) pld
  on we.listingid=cast(pld.listingid as varchar(64))
  and we.datekey=pld.ymdid
  where we.profilekey=1  
    and we.datekey between 20160701 and  20160912
    and we.pagesubkey in (46,68,80)
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
  from apsDimensionalModelweb.fact.webevent we
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
     where dlf.ymdid between 20160701 and  20160912
   ) x
   pivot (max(leadFormOptionID) for x.LeadFormOptionValueid in ([3],[4],[5],[7],[9],[11],[14],[17],[19]) ) p
   ) v
     where (v.BEDBATHLEADSREQ+v.FullNameReq+v.LEADMOVEREASONREQ+v.LEADMOVEDATEREQ+v.LEADMOVEDATECALREQ
         +v.LEADPRICERANGEREQ+v.LEADPHONEREQUIRED+v.LEADCONFIRMEMAIL+v.TWONAMELEADS) > 0
  ) pld
  on we.listingid=cast(pld.listingid as varchar(64))
  and we.datekey=pld.ymdid
  where we.profilekey=1  
    and we.datekey between 20160701 and  20160912
    and we.pagesubkey=302
    and we.actionkey=1
    and we.positionkey=72
  group by  datekey
  ) B
on a.datekey=b.datekey
