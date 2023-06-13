MCom = MCom or {}

MCom.Colors = MCom.Colors or {}

-- ? colors
MCom.Colors.White = Color(250,250,250)
MCom.Colors.Black = Color(0,0,0)
MCom.Colors.Red = Color(240,10,10)
MCom.Colors.Green = Color(10,240,10)
MCom.Colors.Blue = Color(10,10,240)
MCom.Colors.Yellow = Color(240,240,10)
MCom.Colors.Purple = Color(80,0,140)
MCom.Colors.Orange = Color(240,140,10)

MCom.Colors.OrangeDark = Color(160,115,0)
MCom.Colors.OrangeLight = Color(255,200,0)

MCom.Colors.GreenDark = Color(0,160,0)
MCom.Colors.GreenLight = Color(0,255,0)

MCom.Colors.BlueDark = Color(0,0,160)
MCom.Colors.BlueLight = Color(50,50,255)

MCom.Colors.RedDark = Color(140,0,0)
MCom.Colors.RedLight = Color(255,0,0)

MCom.Colors.PurpleDark = Color(80,0,140)
MCom.Colors.Indigo = Color(30,0,135)


-- ? status
MCom.Status = MCom.Status or {}

MCom.Status.None = 0
MCom.Status.Waiting = 1
MCom.Status.InProgress = 2
MCom.Status.Finished = 3
MCom.Status.Failed = 4
MCom.Status.Errored = 5


-- ? command execution codes
MCom.Execution = MCom.Execution or {}

MCom.Execution.None = 0
MCom.Execution.Success = 1
MCom.Execution.Fail = 2
MCom.Execution.Error = 3
MCom.Execution.Unknown = 4
MCom.Execution.Unauthorized = 5