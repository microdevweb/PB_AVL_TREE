;**********************************************************************************************************************
;* PROJECT        : AVL_TREE
;* PROCESS        : manage a avl tree
;* FILE           : main.pbi
;* CONTENT        : main program
;* AUTHOR         : microdedWeb
;* DATE           : 2019/12/18
;**********************************************************************************************************************
;* IMPORT
;**********************************************************************************************************************
EnableExplicit
;**********************************************************************************************************************
;* STRUCTURES / DEFINE / ENUM
;**********************************************************************************************************************
Structure people
  fname.s
  sname.s
  id.l
EndStructure
#DATA_FILE = "import/data.csv"
;**********************************************************************************************************************
;* PROTOTYPE OF FUNCTION
;**********************************************************************************************************************
Declare load_data()
Declare ask()
;**********************************************************************************************************************
;* GLOBAL VARIABLES 
;**********************************************************************************************************************
Global NewList myPeople.people()
;**********************************************************************************************************************
;* RUN PROGRAM
;**********************************************************************************************************************
OpenConsole("AVL Tree LK compare")
EnableGraphicalConsole(1)
PrintN("Please wait we load above 450.000 records, that  can be take some time")
load_data()
ask()
;**********************************************************************************************************************
;* FUNCTIONS
;**********************************************************************************************************************
Procedure load_data()
  Protected d.s,i
  Protected t = ElapsedMilliseconds(),te.f,txt.s
  ; read data file
  OpenFile(0,#DATA_FILE)
  While Eof(0) = 0
    d = ReadString(0)
    If i > 0
      AddElement(myPeople())
      myPeople()\id = Val(StringField(d,1,";"))
      myPeople()\fname = StringField(d,3,";")
      myPeople()\sname = StringField(d,4,";")
    EndIf
    i + 1
  Wend  
  te = (ElapsedMilliseconds() - t) / 1000
  txt = Str(i-1)+" data are loaded in "+StrF(te,2)+" seconds"
  PrintN(txt)
  Input()
EndProcedure

Procedure ask()
  Protected choice.s
  Protected.people *p,*f
  Protected t.f,te.f,found.b = #False
  Repeat
    ClearConsole()
    Print("Enter a id of we look for (betwenn 100008 and 2345813) or empty for exit : ")
    choice = Input()
    If Len(choice)
      t = ElapsedMilliseconds() ; for calculate the  elapsed time
      te = 0
      found = #False
      ForEach myPeople()  
        If myPeople()\id = Val(choice)
          found = #True
          Break
          te = ElapsedMilliseconds() - t
        EndIf
      Next
      If Not te
        te = ElapsedMilliseconds() - t
      EndIf
      PrintN("Request finished in "+StrF(te,2)+" ms")
      If found
        Print("First name : "+myPeople()\fname + " Surname : "+myPeople()\sname + " id : "+Str(myPeople()\id))
      Else
        Print("This id : "+choice+" is not found ")
      EndIf
      Input()
    EndIf
  Until Not Len(choice)
EndProcedure

Procedure free(*d.people)
  FreeStructure(*d)
EndProcedure


; IDE Options = PureBasic 5.71 LTS (Windows - x64)
; CursorPosition = 91
; FirstLine = 79
; Folding = -
; EnableXP