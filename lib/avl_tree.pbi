;**********************************************************************************************************************
;* CLASS          : AVL_TREE
;* PROCESS        : manage a avl tree
;* FILE           : avl_tree.pbi
;* CONTENT        : avlt_tree prototypes
;* AUTHOR         : microdedWeb
;* DATE           : 2019/12/17
;* MAJOR VERSION  : 1
;* MINOR VERSION  : 0 B2
;* HISTORY        : B2 -> add -> free
;**********************************************************************************************************************
DeclareModule AVL_TREE
  Interface tree
    ;*******************************************************************
    ;* PUBLIC METHOD : add
    ;* PROCESS       : add a new item to avl tree
    ;* ARGUMENT      : content -> that is a pointer on your structure
    ;* RETURN        : VOID
    ;*******************************************************************
    add(content)
    ;*******************************************************************
    ;* PUBLIC METHOD : search
    ;* PROCESS        : search a node
    ;* ARGUMENT       : *toSearch -> structure to search
    ;* RETURN         : *n._NODE or 0 if not found
    ;*******************************************************************
    search(toSearch)
    ;*******************************************************************
    ;* PUBLIC METHOD  : free
    ;* PROCESS        : free node
    ;* ARGUMENT       : *free  -> personal user function
    ;                             procedure myProcedure(*item.StructItem)
    ;                                   freeStructure(StructItem)
    ;                             EndProcedure
    ;* RETURN         : *n._NODE or 0 if not found
    ;*******************************************************************
    free(functionToFree)
    ;*******************************************************************
    ;* PUBLIC METHOD : display
    ;* PROCESS       : display node for debug it
    ;* ARGUMENT      : *mth -> personal user function
    ;                          procedure.s myFunction(*content)
    ;                               procedureReturn valueToDisplaying.s
    ;                          EndProcedure
    ;* RETURN        : VOID
    ;*******************************************************************
    display(mth)
  EndInterface
  
  Interface node
    ;*******************************************************************
    ;* PUBLIC METHOD : get_content
    ;* PROCESS       : get content address from the node
    ;* ARGUMENT      : VOID
    ;* RETURN        : content
    ;*******************************************************************
    get_content()
  EndInterface
  ;*********************************************************************
  ;* CONSTRUCTOR :
  ;* ARGUMENTS   : *cmp  -> it's the address off your  procedure(*a,*b) 
  ;*                                    it will return 1 if a > b         
  ;*                                                  -1 if a < b  
  ;*                                                   0 if a = b
  ;*********************************************************************
  Declare new_tree(*cmp)
EndDeclareModule

XIncludeFile "_avl_tree.pbi"

; IDE Options = PureBasic 5.71 LTS (Windows - x64)
; CursorPosition = 36
; FirstLine = 15
; Folding = -
; EnableXP