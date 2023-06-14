SELECT pg_lip_bloom_set_dynamic(2);
SELECT pg_lip_bloom_init(0);


/*+
NestLoop(t s tq q)
NestLoop(t s tq)
HashJoin(t s)
IndexScan(tq)
IndexScan(q)
SeqScan(t)
SeqScan(s)
Leading((((t s) tq) q))
*/
 SELECT COUNT(*) 
 
FROM 
tag as t,
site as s,
question as q,
tag_question as tq
WHERE 
 
 t.site_id = s.site_id 
 AND q.site_id = s.site_id 
 AND tq.site_id = s.site_id 
 AND tq.question_id = q.id 
 AND tq.tag_id = t.id 
 AND (s.site_name in ('stackoverflow')) 
 AND (t.name in ('datatable','delegates','django-forms','extjs','google-api','google-app-engine','numbers','promise','python-3.x','svn','tdd','typescript','uitableview','x86')) 
 AND (q.favorite_count >= 0) 
 AND (q.favorite_count <= 10000) 
  
;