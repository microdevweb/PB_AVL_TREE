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
XIncludeFile "lib/avl_tree.pbi"
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
Declare compare(*a.people,*b.people)
Declare load_data()
Declare ask()
Declare free(*d.people)
;**********************************************************************************************************************
;* GLOBAL VARIABLES 
;**********************************************************************************************************************
Global myTree.AVL_TREE::tree = AVL_TREE::new_tree(@compare())
;**********************************************************************************************************************
;* RUN PROGRAM
;**********************************************************************************************************************
OpenConsole("AVL Tree")
EnableGraphicalConsole(1)
PrintN("Please wait we load above 450.000 records, that  can be take some time")
PrintN("For must performs please disable the debuger :)")
load_data()
ask()
;**********************************************************************************************************************
;* FUNCTIONS
;**********************************************************************************************************************
Procedure compare(*a.people,*b.people)
  If *a\id > *b\id : ProcedureReturn 1 : EndIf
  If *a\id < *b\id : ProcedureReturn -1 : EndIf
  ProcedureReturn 0
EndProcedure

Procedure load_data()
  Protected d.s,*p.people,i
  Protected t = ElapsedMilliseconds(),te.f,txt.s
  ; read data file
  OpenFile(0,#DATA_FILE)
  While Eof(0) = 0
    d = ReadString(0)
    If i > 0
      *p = AllocateStructure(people)
      *p\id = Val(StringField(d,1,";"))
      *p\fname = StringField(d,3,";")
      *p\sname = StringField(d,4,";")
      myTree\add(*p)
    EndIf
    i + 1
  Wend  
  te = (ElapsedMilliseconds() - t) / 1000
  txt = Str(i-1)+" data are loaded in "+StrF(te,2)+" seconds (press any keys for next step)"
  PrintN(txt)
  Input()
EndProcedure

Procedure ask()
  Protected choice.s
  Protected.people *p,*f
  Protected t.f,te.f
  Repeat
    ClearConsole()
    Print("Enter a id of we look for (betwenn 100008 and 2345813) or empty for exit : ")
    choice = Input()
    If Len(choice)
      ; make find structure
      *p = AllocateStructure(people)
      *p\id = Val(choice)
      t = ElapsedMilliseconds() ; for calculate the  elapsed time
      *f = myTree\search(*p)
      te = ElapsedMilliseconds() - t
      PrintN("Request finished in "+StrF(te,2)+" ms")
      If *f
        Print("First name : "+*f\fname + " Surname : "+*f\sname + " id : "+Str(*f\id))
      Else
        Print("This id : "+Str(*p\id)+" is not found ")
      EndIf
      FreeStructure(*p)
      Input()
    EndIf
  Until Not Len(choice)
  myTree\free(@free())
EndProcedure

Procedure free(*d.people)
  FreeStructure(*d)
EndProcedure


; IDE Options = PureBasic 5.71 LTS (Windows - x64)
; CursorPosition = 38
; FirstLine = 33
; Folding = -
; EnableXP