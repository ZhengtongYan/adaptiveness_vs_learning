SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(t1 s tq1 a1 u1 q1)
NestLoop(t1 s tq1 a1 u1)
HashJoin(t1 s tq1 a1)
NestLoop(t1 s tq1)
HashJoin(t1 s)
IndexScan(tq1)
IndexScan(a1)
IndexScan(u1)
IndexScan(q1)
SeqScan(t1)
SeqScan(s)
Leading((((((t1 s) tq1) a1) u1) q1))
*/
 SELECT t1.name, count(*) 
 
FROM 
site as s,
so_user as u1,
question as q1,
answer as a1,
tag as t1,
tag_question as tq1
WHERE 
 
 q1.owner_user_id = u1.id 
 AND a1.question_id = q1.id 
 AND a1.owner_user_id = u1.id 
 AND s.site_id = q1.site_id 
 AND s.site_id = a1.site_id 
 AND s.site_id = u1.site_id 
 AND s.site_id = tq1.site_id 
 AND s.site_id = t1.site_id 
 AND q1.id = tq1.question_id 
 AND t1.id = tq1.tag_id 
 AND (s.site_name in ('stackoverflow','tex','unix')) 
 AND (t1.name in ('algorithm','asp.net-mvc','c++11','css3','docker','google-maps','math','mongodb','mysql','oop','r','spring','swift','unix')) 
 AND (q1.favorite_count >= 5) 
 AND (q1.favorite_count <= 5000) 
 AND (u1.reputation >= 0) 
 AND (u1.reputation <= 10) 
 GROUP BY t1.name 
;