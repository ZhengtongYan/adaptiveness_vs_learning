SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(s t1 tq1 q1 u1 b1 acc)
NestLoop(s t1 tq1 q1 u1 b1)
NestLoop(s t1 tq1 q1 u1)
NestLoop(s t1 tq1 q1)
NestLoop(s t1 tq1)
NestLoop(s t1)
IndexScan(tq1)
IndexScan(acc)
IndexScan(q1)
IndexScan(u1)
IndexScan(b1)
SeqScan(t1)
SeqScan(s)
Leading(((((((s t1) tq1) q1) u1) b1) acc))
*/
 SELECT COUNT(*) 
 
FROM 
site as s,
so_user as u1,
tag as t1,
tag_question as tq1,
question as q1,
badge as b1,
account as acc
WHERE 
 
 s.site_id = u1.site_id 
 AND s.site_id = b1.site_id 
 AND s.site_id = t1.site_id 
 AND s.site_id = tq1.site_id 
 AND s.site_id = q1.site_id 
 AND t1.id = tq1.tag_id 
 AND q1.id = tq1.question_id 
 AND q1.owner_user_id = u1.id 
 AND acc.id = u1.account_id 
 AND b1.user_id = u1.id 
 AND (q1.view_count >= 100) 
 AND (q1.view_count <= 100000) 
 AND s.site_name = 'stackoverflow' 
 AND (t1.name in ('facebook-javascript-sdk','upgrade')) 
 AND (acc.website_url ILIKE ('%')) 
  
;