SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(b2 so_user account b1)
NestLoop(b2 so_user account)
NestLoop(b2 so_user)
IndexScan(so_user)
IndexScan(account)
IndexScan(b1)
SeqScan(b2)
Leading((((b2 so_user) account) b1))
*/
  
 SELECT count(distinct account.display_name) 
FROM 
account,
so_user,
badge b1,
badge b2
WHERE 
 
 account.website_url != '' AND 
 account.id = so_user.account_id AND 
  
 b1.site_id = so_user.site_id AND 
 b1.user_id = so_user.id AND 
 b1.name = 'Caucus' AND 
  
 b2.site_id = so_user.site_id AND 
 b2.user_id = so_user.id AND 
 b2.name = 'Epic' AND 
 b2.date > b1.date + '7 months'::interval 
  
;