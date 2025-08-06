WITH
transactions as(
SELECT
id,
SAFE_CAST(left(date, 10) AS DATE) as date,
client_id,
card_id,
CAST(LTRIM(amount, '$') AS FLOAT64) AS amount,
use_chip,
merchant_id,
merchant_city,
merchant_state,
zip,
mcc,
errors
FROM
  `encoded-horizon-463806-e8.mandiri_sekuritas.transactions_data`
)

,cards as(
select
id,
client_id,
card_brand,
card_type,
has_chip,
credit_limit,
card_on_dark_web
from `encoded-horizon-463806-e8.mandiri_sekuritas.cards_data`
group by 1,2,3,4,5,6,7
)

,users as(
select
id,
current_age,
retirement_age,
birth_year,
birth_month,
gender,
latitude,
longitude,
CAST(LTRIM(per_capita_income, '$') AS INT64) as per_capita_income,
CAST(LTRIM(yearly_income, '$') AS INT64) as yearly_income,
CAST(LTRIM(total_debt, '$') AS INT64) as total_debt,
credit_score
from `encoded-horizon-463806-e8.mandiri_sekuritas.users_data`
)

,final as(
select
t.id,
t.date as transaction_date,
extract(year from t.date) as transaction_year,
extract(month from t.date) as transaction_month,
t.client_id,
u.current_age,
case 
    when u.current_age > 15 and u.current_age < 25 then 'Youth'
    when u.current_age >= 25 and u.current_age < 65 then 'Adults'
    when u.current_age >= 65 then 'Seniors'
    else 'Children'
end as current_age_category,
u.retirement_age,
u.birth_year,
u.birth_month,
u.gender,
u.latitude,
u.longitude,
u.per_capita_income,
u.yearly_income,
u.total_debt,
u.credit_score,
case 
    when u.credit_score < 580 then'Poor'
    when u.credit_score >= 580 and u.credit_score < 670 then 'Fair'
    when u.credit_score >= 670 and u.credit_score < 740 then 'Good'
    when u.credit_score >= 740 and u.credit_score < 800 then 'Very Good'
    else 'Excellent'
end as credit_score_category,
t.card_id,
c.card_brand,
c.card_type,
c.has_chip,
c.credit_limit,
c.card_on_dark_web,
t.amount,
t.use_chip,
t.merchant_id,
t.merchant_city,
t.merchant_state,
t.zip,
t.mcc,
t.errors,
SUM(c.credit_limit) AS total_credit_limit,
  ROUND(SAFE_DIVIDE(u.total_debt, SUM(c.credit_limit)),2) AS debt_to_credit_ratio,
  CASE 
    WHEN ROUND(SAFE_DIVIDE(u.total_debt, SUM(c.credit_limit)),2) <0.3 THEN 'Healthy'
    WHEN ROUND(SAFE_DIVIDE(u.total_debt, SUM(c.credit_limit)),2) >=0.3 and ROUND(SAFE_DIVIDE(u.total_debt, SUM(c.credit_limit)),2) <=0.5 THEN 'Watchful'
    ELSE 'Risk'
  END AS debt_to_credit_ratio_category
from transactions as t
left join users as u
on t.client_id = u.id
left join cards as c
on t.card_id = c.id
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32
)

select
transaction_date,
transaction_year,
transaction_month,
current_age_category,
gender,
credit_score_category,
debt_to_credit_ratio_category,
card_brand,
card_type,
use_chip,
merchant_city,
count(distinct client_id) as total_user,
count(distinct card_id) as total_card,
count(distinct id) as total_transaction,
round(sum(amount),2) as total_amount
from final
group by 1,2,3,4,5,6,7,8,9,10,11
