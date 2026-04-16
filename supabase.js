import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

export const SUPABASE_URL = 'https://flvhzqtsguuxozxlckov.supabase.co';
export const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZsdmh6cXRzZ3V1eG96eGxja292Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYzNTAwMTMsImV4cCI6MjA5MTkyNjAxM30.zCL9le2YFrghI82Z9eeI383MOJTk6G9beSCH24pyRTQ';

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

export async function requireAuth() {
  const { data } = await supabase.auth.getSession();
  if (!data.session) {
    window.location.replace('/login');
    return null;
  }
  return data.session;
}

export async function logout() {
  await supabase.auth.signOut();
  window.location.replace('/login');
}
