-- View: project.latest_plans

 DROP VIEW project.latest_plans;

CREATE OR REPLACE VIEW project.latest_plans AS 
 SELECT p1.plan_id,
    p1.project_id,
    p1.main_no,
    p1.sub_no,
    p1.version,
    p1.url,
    p1.approved,
    p1.created_at,
    p1.created_by,
    p1.updated_at,
    p1.updated_by,
    p1.deleted
   FROM ( SELECT max(p2.version) AS maxversion,
            p2.main_no,
            p2.sub_no
           FROM project.plan p2
           WHERE deleted = false
          GROUP BY p2.main_no, p2.sub_no) tmp
     JOIN project.plan p1 ON p1.main_no = tmp.main_no AND p1.sub_no = tmp.sub_no AND p1.version = tmp.maxversion
UNION ALL
 SELECT p1.plan_id,
    p1.project_id,
    p1.main_no,
    p1.sub_no,
    p1.version,
    p1.url,
    p1.approved,
    p1.created_at,
    p1.created_by,
    p1.updated_at,
    p1.updated_by,
    p1.deleted
   FROM ( SELECT max(p2.version) - 1 AS maxversion,
            p2.main_no,
            p2.sub_no
           FROM project.plan p2
           WHERE deleted = false
          GROUP BY p2.main_no, p2.sub_no) tmp
     JOIN project.plan p1 ON p1.main_no = tmp.main_no AND p1.sub_no = tmp.sub_no AND p1.version = tmp.maxversion;

ALTER TABLE project.latest_plans
  OWNER TO pythiaservice;
GRANT ALL ON TABLE project.latest_plans TO pythiaservice;

