import { supabaseAdmin } from '@/lib/supabase';
import { NextRequest, NextResponse } from 'next/server';

export async function POST(req: NextRequest) {
  const body = await req.json();
  const { data, error } = await supabaseAdmin
    .from('responses')
    .insert([{
      id: body.id,
      training_id: body.trainingId,
      lect: body.lect,
      recommend_lecture: body.recommendLecture,
      need: body.need,
      etc: body.etc,
      submitted_at: body.at
    }]);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ ok: true });
}

export async function GET(req: NextRequest) {
  const tid = req.nextUrl.searchParams.get('trainingId');
  const query = supabaseAdmin.from('responses').select('*');
  if (tid) query.eq('training_id', tid);
  const { data, error } = await query.order('submitted_at', { ascending: false });
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json(data);
}
