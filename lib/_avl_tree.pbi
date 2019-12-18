;**********************************************************************************************************************
;* CLASS          : AVL_TREE
;* PROCESS        : manage a avl tree
;* FILE           : _avl_tree.pbi
;* CONTENT        : avlt_tree implementation
;* AUTHOR         : microdedWeb
;* DATE           : 2019/12/17
;* MAJOR VERSION  : 1
;* MINOR VERSION  : 0 B2
;* HISTORY        : B2 -> add -> free
;**********************************************************************************************************************
Module AVL_TREE
  EnableExplicit
  Prototype.l cmp(*a,*b) 
  Prototype.s dsp(*n)
  Prototype pfree(*n)
  Structure _NODE
    *methods
    *content
    *right._NODE
    *left._NODE
    height.l
  EndStructure
  Structure _AVL
    *methods
    *root._NODE
    *cmp.cmp
  EndStructure
  ;*******************************************************************
  ;* PRIVATE METHODS
  ;*******************************************************************
  Declare insert(*this._AVL,*n._NODE,*content)
  Declare max(a,b)
  Declare height(*n._NODE)
  Declare new_node(*content)
  Declare right_rotate(*y._NODE)
  Declare left_rotate(*x._NODE)
  Declare get_balance(*n._NODE)
  Declare _search(*this._AVL,*n._NODE,*toSearch)
  Declare _free(*n._NODE,*free)
  ;*******************************************************************
  ;* PRIVATE METHOD : insert
  ;* PROCESS        : insert a item at avl tree
  ;* ARGUMENT       : *n._NODE -> current avl tree
  ;                   *content   -> content to insert
  ;* RETURN         : VOID
  ;*******************************************************************
  Procedure insert(*this._AVL,*n._NODE,*content)
    With *this
      ; 1 perform the normal tree insertion
      If Not *n
        ProcedureReturn new_node(*content)
      EndIf
      If \cmp(*content,*n\content) < 0
        *n\left = insert(*this,*n\left,*content)
      ElseIf \cmp(*content,*n\content) > 0
        *n\right = insert(*this,*n\right,*content)
      Else ; equal are not allowed at this time
        ProcedureReturn *n
      EndIf
      ; 2 update height of this ancestor node
      *n\height = 1 + max(height(*n\left),height(*n\right))
      ; 3 get the balance factor of this ancestor 
      ; node to chack whether this node became unbalanced
      Define balance = get_balance(*n) 
      ; if this node becomes unbalanced, then there are 4 cases
      ; -> left left case
      If balance > 1 And \cmp(*content,*n\left\content)<0
        ProcedureReturn right_rotate(*n)
      EndIf
      ; -> right right case
      If balance < -1 And \cmp(*content,*n\right\content)>0
        ProcedureReturn left_rotate(*n)
      EndIf
      ; -> left right case
      If balance > 1 And \cmp(*content,*n\left\content)>0
        *n\left = left_rotate(*n\left)
        ProcedureReturn right_rotate(*n)
      EndIf
      ; -> right left case
      If balance < -1 And \cmp(*content,*n\right\content)<0
        *n\right = right_rotate(*n\right)
        ProcedureReturn left_rotate(*n)
      EndIf
      ; return the unchanged node
      ProcedureReturn *n
    EndWith
  EndProcedure
  ;*******************************************************************
  ;* PRIVATE METHOD : max
  ;* PROCESS        : return the greater value between 2 integer
  ;* ARGUMENT       : a       -> first value
  ;                   a       -> second value
  ;* RETURN         : integer -> upper value
  ;*******************************************************************
  Procedure max(a,b)
    If a > b
      ProcedureReturn a
    Else
      ProcedureReturn b
    EndIf
  EndProcedure
  ;*******************************************************************
  ;* PRIVATE METHOD : height
  ;* PROCESS        : return the height of a node or 0 if node is null
  ;* ARGUMENT       : *n._NODE -> node to ask
  ;* RETURN         : integer  -> height to node
  ;*******************************************************************
  Procedure height(*n._NODE)
    With *n
      If Not *n:ProcedureReturn 0:EndIf
      ProcedureReturn \height
    EndWith
  EndProcedure
  ;*******************************************************************
  ;* PRIVATE METHOD : new_node
  ;* PROCESS        : allocate a new node and return it
  ;* ARGUMENT       : *content  -> node content
  ;* RETURN         : *node
  ;*******************************************************************
  Procedure new_node(*content)
    Protected *n._NODE = AllocateStructure(_NODE)
    With *n
      \content = *content
      \left = 0
      \right = 0
      \height = 1
      ProcedureReturn *n
    EndWith
  EndProcedure
  ;*******************************************************************
  ;* PRIVATE METHOD : right_rotate
  ;* PROCESS        : rotate a node to right
  ;* ARGUMENT       : *y -> node to rotate
  ;* RETURN         : *_NODE -> new root
  ;*******************************************************************
  Procedure right_rotate(*y._NODE)
    Protected *x._NODE = *y\left
    Protected *T2._NODE = *x\right
    ; Perform rotation
    *x\right = *y
    *y\left = *T2
    ; update height
    *y\height = max(height(*y\left),height(*y\right))+1
    *x\height = max(height(*x\left),height(*x\right))+1
    ; return the new root
    ProcedureReturn *x
  EndProcedure
  ;*******************************************************************
  ;* PRIVATE METHOD : right_rotate
  ;* PROCESS        : rotate a node to right
  ;* ARGUMENT       : *y -> node to rotate
  ;* RETURN         : *_NODE -> new root
  ;*******************************************************************
  Procedure left_rotate(*x._NODE)
    Protected *y._NODE = *x\right
    Protected *T2._NODE = *y\left
    ; Perform rotation
    *y\left = *x
    *x\right = *T2
    ; update height
    *x\height = max(height(*x\left),height(*x\right))+1
    *y\height = max(height(*y\left),height(*y\right))+1
    ; return the new root
    ProcedureReturn *y
  EndProcedure
  ;*******************************************************************
  ;* PRIVATE METHOD : get_balance
  ;* PROCESS        : get balance factor
  ;* ARGUMENT       : *n._NODE -> node to ask
  ;* RETURN         : int balance factor
  ;*******************************************************************
  Procedure get_balance(*n._NODE)
    With *n
      If Not *n :ProcedureReturn  0 :EndIf
      ProcedureReturn height(*n\left) - height(*n\right)
    EndWith
  EndProcedure
  ;*******************************************************************
  ;* PRIVATE METHOD : _disp
  ;* PROCESS        : display node
  ;* ARGUMENT       : *n._NODE -> node to display
  ;* RETURN         : VOID
  ;* NOTE           : recursive method
  ;*******************************************************************
  Procedure _disp(*n._NODE,*mth,n)
    Protected f.dsp = *mth
    With *n
      If *n
        Print("N : "+Str(n)+"  ")
        Print(f(*n\content))
        If *n\left
          Print(" / ")
        EndIf
        _disp(*n\left,*mth,n+1)
        If *n\right
          Print(" \ ")
        EndIf
        _disp(*n\right,*mth,n+1)
      EndIf
    EndWith
  EndProcedure
  ;*******************************************************************
  ;* PRIVATE METHOD : _search
  ;* PROCESS        : search a node
  ;* ARGUMENT       : *n._NODE   -> root to begin
  ;                    *toSearch -> structure to search
  ;* RETURN         : *n._NODE or 0 if not found
  ;* NOTE           : recursive method
  ;*******************************************************************
  Procedure _search(*this._AVL,*n._NODE,*toSearch)
    With *this
      ; not found
      If Not *n
        ProcedureReturn 0
      EndIf
      If \cmp(*toSearch,*n\content) = 0
        ProcedureReturn *n\content
      EndIf
      If \cmp(*toSearch,*n\content) > 0
        ProcedureReturn _search(*this,*n\right,*toSearch)
      EndIf
      If \cmp(*toSearch,*n\content) < 0
        ProcedureReturn _search(*this,*n\left,*toSearch)
      EndIf
    EndWith
  EndProcedure
  ;*******************************************************************
  ;* PRIVATE METHOD : _free
  ;* PROCESS        : free node
  ;* ARGUMENT       : *n._NODE -> node to free
  ;                   *free  -> personal user function
  ;                             procedure myProcedure(*item.StructItem)
  ;                                   freeStructure(StructItem)
  ;                             EndProcedure
  ;* RETURN         : *n._NODE or 0 if not found
  ;*******************************************************************
  Procedure _free(*n._NODE,*free)
    With *this
      Protected f.pfree = *free
      If *n
        _free(*n\left,*free)
        _free(*n\right,*free)
        f(*n\content)
        FreeStructure(*n)
      EndIf
    EndWith
  EndProcedure
  
  ;*******************************************************************
  ;*PUBLIC METHODS AVL
  ;*******************************************************************
  ;*******************************************************************
  ;* PUBLIC METHOD : add
  ;* PROCESS       : add a new item to avl tree
  ;* ARGUMENT      : content -> that is a pointer on your structure
  ;* RETURN        : VOID
  ;*******************************************************************
  Procedure add(*this._AVL,*content) 
    With *this
      \root = insert(*this,\root,*content)
      ProcedureReturn \root
    EndWith
  EndProcedure
  ;*******************************************************************
  ;* PUBLIC METHOD : search
  ;* PROCESS        : search a node
  ;* ARGUMENT       : *toSearch -> structure to search
  ;* RETURN         : *n._NODE or 0 if not found
  ;*******************************************************************
  Procedure search(*this._AVL,*toSearch)
    With *this
      ProcedureReturn _search(*this,\root,*toSearch)
    EndWith
  EndProcedure
  ;*******************************************************************
  ;* PUBLIC METHOD  : free
  ;* PROCESS        : free node
  ;* ARGUMENT       : *free  -> personal user function
  ;                             procedure myProcedure(*item.StructItem)
  ;                                   freeStructure(StructItem)
  ;                             EndProcedure
  ;* RETURN         : *n._NODE or 0 if not found
  ;*******************************************************************
  Procedure free(*this._AVL,*free)
    With *this
      _free(\root,*free)
      FreeStructure(*this)
    EndWith
  EndProcedure
  ;*******************************************************************
  ;* PUBLIC METHOD : display
  ;* PROCESS       : display node for debug it
  ;* ARGUMENT      : *mth -> personal user function
  ;                          procedure.s myFunction(*content)
  ;                               procedureReturn valueToDisplaying.s
  ;                          EndProcedure
  ;* RETURN        : VOID
  ;*******************************************************************
  Procedure display(*this._AVL,*mth)
    With *this
      _disp(\root,*mth,1)
    EndWith
  EndProcedure
  
  ;*******************************************************************
  ;*PUBLIC METHODS NODE
  ;*******************************************************************
  ;*******************************************************************
  ;* PUBLIC METHOD : get_content
  ;* PROCESS       : get content address from the node
  ;* ARGUMENT      : VOID
  ;* RETURN        : content
  ;*******************************************************************
  Procedure get_content(*this._NODE)
    With *this
      ProcedureReturn \content
    EndWith
  EndProcedure
  ;*********************************************************************
  ;*CONSTRUCTOR
  ;*********************************************************************
  Procedure new_tree(*cmp)
    Protected  *this._AVL = AllocateStructure(_AVL)
    With *this
      \methods = ?avl_start
      \cmp = *cmp
      ProcedureReturn *this
    EndWith
  EndProcedure
  ; AVL METHODS
  DataSection
    avl_start:
    Data.i @add()
    Data.i @search()
    Data.i @free()
    Data.i @display()
    avl_end:
  EndDataSection
  ; NODE METHODS
  DataSection
    node_start:
    Data.i @get_content()
    node_end:
  EndDataSection  
EndModule

; IDE Options = PureBasic 5.71 LTS (Windows - x64)
; CursorPosition = 240
; FirstLine = 118
; Folding = BQi
; EnableXP