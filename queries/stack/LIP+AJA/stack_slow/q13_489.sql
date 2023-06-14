SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(6);
SELECT sum(pg_lip_bloom_add(0, u1.site_id)), sum(pg_lip_bloom_add(1, u1.id)), sum(pg_lip_bloom_add(2, u1.site_id)) FROM so_user AS u1 
        WHERE ((u1.downvotes >= 10) AND (u1.downvotes <= 100000)) AND ((u1.downvotes >= 10) AND (u1.downvotes <= 100000)) AND ((u1.downvotes >= 10) AND (u1.downvotes <= 100000));
SELECT sum(pg_lip_bloom_add(3, b.site_id)), sum(pg_lip_bloom_add(4, b.site_id)), sum(pg_lip_bloom_add(5, b.user_id)) FROM badge AS b 
        WHERE ((b.name)::text = ANY ('{Excavator,Explainer,Pundit,"Tag Editor"}'::text[])) AND ((b.name)::text = ANY ('{Excavator,Explainer,Pundit,"Tag Editor"}'::text[])) AND ((b.name)::text = ANY ('{Excavator,Explainer,Pundit,"Tag Editor"}'::text[]));


/*+
NestLoop(s t1 tq1 a1 u1 q1 b acc)
NestLoop(s t1 tq1 a1 u1 q1 b)
NestLoop(s t1 tq1 a1 u1 q1)
NestLoop(s t1 tq1 a1 u1)
NestLoop(s t1 tq1 a1)
NestLoop(s t1 tq1)
HashJoin(s t1)
IndexScan(tq1)
IndexScan(acc)
IndexScan(a1)
IndexScan(u1)
IndexScan(q1)
IndexScan(b)
SeqScan(t1)
SeqScan(s)
Leading((((((((s t1) tq1) a1) u1) q1) b) acc))
*/
 SELECT acc.location, count(*) 
 
FROM 
(
    SELECT * FROM site as s
    WHERE 
pg_lip_bloom_probe(0, s.site_id)  AND pg_lip_bloom_probe(3, s.site_id) 
) AS s,
so_user as u1,
question as q1,
(
    SELECT * FROM answer as a1
    WHERE 
pg_lip_bloom_probe(1, a1.owner_user_id)  AND pg_lip_bloom_probe(2, a1.site_id)  AND pg_lip_bloom_probe(4, a1.site_id)  AND pg_lip_bloom_probe(5, a1.owner_user_id) 
) AS a1,
tag as t1,
tag_question as tq1,
badge as b,
account as acc
WHERE 
 
 s.site_id = q1.site_id 
 AND s.site_id = u1.site_id 
 AND s.site_id = a1.site_id 
 AND s.site_id = t1.site_id 
 AND s.site_id = tq1.site_id 
 AND s.site_id = b.site_id 
 AND q1.id = tq1.question_id 
 AND q1.id = a1.question_id 
 AND a1.owner_user_id = u1.id 
 AND t1.id = tq1.tag_id 
 AND b.user_id = u1.id 
 AND acc.id = u1.account_id 
 AND (s.site_name in ('apple','drupal','english','ru','tex')) 
 AND (t1.name in ('beamer','equations')) 
 AND (q1.view_count >= 100) 
 AND (q1.view_count <= 100000) 
 AND (u1.downvotes >= 10) 
 AND (u1.downvotes <= 100000) 
 AND (b.name in ('Excavator','Explainer','Pundit','Tag Editor')) 
 GROUP BY acc.location 
 ORDER BY COUNT(*) 
 DESC 
 LIMIT 100 
  
;