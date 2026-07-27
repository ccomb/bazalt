module MessageId where

import Data.UUID (UUID)
import MessageFlow (MessageFlow)

type MessageId = (UUID, MessageFlow)
