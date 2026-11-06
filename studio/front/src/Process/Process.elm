module Process.Process exposing (compare)

import Prng.Uuid as Uuid



-- a process is the wrapper around related partial events
-- Processes are independant and unrelated one another
--merge : Process -> Process -> Process
-- TODO : we start 2 independent sales but the customer pays for both
-- at the same time : then it's the same process
-- Looks like a process can have several contracts?


compare : Process -> String
compare =
    Uuid.toString << .uuid
