/* Auto-generation by Bash script */

import { Route, createRoutesFromElements } from 'react-router-dom'
import App from './App'
import loginLoader from '@loaders/User/login.ts'
import verifyLoader from '@loaders/User/verify.ts'

const routes = createRoutesFromElements(
  <Route element={<App />}>
    <Route path='/user/login' loader={loginLoader} lazy={() => import('@pages/User/Login.tsx')} />
    <Route path='/user/sign-up' lazy={() => import('@pages/User/SignUp.tsx')} />
    <Route path='/user/verify' loader={verifyLoader} lazy={() => import('@pages/User/Verify.tsx')} />
  </Route>,
)

export default routes
