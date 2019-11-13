{-# LANGUAGE OverloadedStrings, DataKinds, MultiParamTypeClasses #-}
--
module ApiServer ( apiServer ) where
--
import Servant
import Network.Wai.Handler.Warp (run)
import Data.Text.Lazy (Text)
import Data.Text.Lazy.Encoding (encodeUtf8)

import Network.HTTP.Media ( (//), (/:) )
import ApiServer.Middleware (middleware)
--

-- http://mydomain.com
-- http://mydomain.com/demo

data HTML

instance Accept HTML where
  contentType _ = "text" // "html" /: ("charse", "utf-8")

instance MimeRender HTML Text where
  mimeRender _ = encodeUtf8

type ServerAPI = Get '[HTML] Text

serverRoutes :: Server ServerAPI
serverRoutes = return "Hello from Home!"

serverProxy :: Proxy ServerAPI
serverProxy = Proxy

router :: Application
router = serve serverProxy serverRoutes

apiServer :: IO ()
apiServer = run 80 (middleware router)
