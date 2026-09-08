-- ============================================================
-- "강사피드백", "결과보고서 > 기타 보고 사항", "교육진행안 > 기타 보고 사항",
-- "교육진행안 > 교육 대상자 표의 열 숨김 설정", "결과보고서 > 강의별 주요 의견(편집·삭제)",
-- "결과보고서 > 교육 사진 개수 선택"에
-- 저장한 내용이 다른 사람에게도 보이게 하려면 Supabase SQL Editor에서 아래를 1회 실행해주세요.
-- (지금까지는 모두 저장 시 서버로 전달되지 않는 버그가 있었어서
--  이번에 코드를 고치면서 서버 컬럼도 함께 준비해두는 겁니다.)
-- ============================================================

alter table trainings add column if not exists feedback jsonb default '{}'::jsonb;
alter table trainings add column if not exists report_etc text default '';
alter table trainings add column if not exists agenda_etc text default '';
alter table trainings add column if not exists att_hide_cols jsonb default '[]'::jsonb;
alter table trainings add column if not exists report_opinions jsonb default '{}'::jsonb;
alter table trainings add column if not exists photo_count integer default 6;

-- ============================================================
-- "출석현황" — 여러 명이 QR로 거의 동시에 출석 등록하면(교육 시작 직전에 흔한 상황),
-- 예전 방식(교육 하나에 출석자 전체를 배열 하나로 저장)은 서로 덮어써서 몇 명만 남는
-- 문제가 있었습니다. 한 명당 한 행으로 저장하는 별도 테이블을 새로 만들어서 이 문제를 없앱니다.
-- ============================================================
create table if not exists checkins(
  id text primary key,
  training_id text not null,
  emp_no text not null,
  name text not null,
  at timestamptz not null default now()
);
create index if not exists checkins_training_id_idx on checkins(training_id);
