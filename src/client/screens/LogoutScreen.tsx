import { useEffect } from 'react';
import { useQueryClient } from '@tanstack/react-query';
import { signOut } from '@/client/api/session';

/** /logout signs out and goes home. */
export default function LogoutScreen() {
  const qc = useQueryClient();
  useEffect(() => {
    qc.clear();
    signOut();
    window.location.replace('/');
  }, [qc]);
  return null;
}
