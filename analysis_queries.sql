-- total applicants 
select count(*) as total_applicants
from applicants;

-- applicants per stage 
select stage, count(*) as count
from Applications
group by stage;

-- applicants who reached each stage
select stage, count(distinct applicant_id) as applicants
from Applications
group by stage
order by applicants desc;

-- Drop-off after test stage
select count(distinct applicant_id) as dropped_after_test
from Applications
where stage = 'test'
and applicant_id not in (
    select applicant_id
    from Applications
    where stage = 'interview'
);

-- offer conversion rate
select 
(select count(*) from Applications where stage = 'offer') * 100.0 
/ count(*) as offer_percentage
from Applications;

-- college-wise offers
select a.college, count(*) as offers
from Applicants a
join applications ap
on a.applicant_id = ap.applicant_id
where ap.stage = 'offer'
group by a.college;

-- degree wise success
select a.degree,
count(case when ap.stage='offer' then 1 end) as offers
from applicants a
join applications ap
on a.applicant_id = ap.applicant_id
group by a.degree;

-- who are the top performers? Offer % by college
select a.college,
count(case when ap.stage='offer' then 1 end) * 100.0 / count(*) as offer_rate
from applicants a
join applications ap
on a.applicant_id = ap.applicant_id
group by a.college
order by offer_rate desc;

-- early vs late success analysis
select
case
when stage_date <= '2024-01-15' then'early'
else 'late'
end as application_time,
count(case when stage='offer' then 1 end) as offers
from Applications
group by application_time;

-- if we improve interview success by 10%  how many more offers?
select
count(case when stage='offer' then 1 end) +
(0.1 * count(case when stage='interview' then 1 end)) 
as projected_offers
from Applications;

-- insights 
-- drop off rate per stage 
select stage,
count(*) as applicants,
round(
count(*) * 100.0 /
(select count(*) from Applications),
2
) as stage_percentage
from Applications
group by stage
order by applicants desc;

-- colleges with high interview success
select a.college,
count(case when ap.stage='offer' then 1 end) * 100.0 /
count(case when ap.stage='interview' then 1 end) as interview_success_rate
from applicants a
join applications ap
on a.applicant_id = ap.applicant_id
group by a.college
having count(case when ap.stage='interview' then 1 end) > 0
order by interview_success_rate desc;
