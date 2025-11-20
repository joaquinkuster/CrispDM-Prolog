% reglas_hongos.pl
% Implementación Prolog final derivada del árbol de decisión documentado.

% -------------------------
% Hechos base (documentados)
% -------------------------
ingerible('abultada', 'almendra').
ingerible('abultada', 'ninguno', 'cercano').
venenoso('abultada', 'mohoso').
venenoso('abultada', 'ninguno', 'poblado').

% -------------------------
% Reglas derivadas del árbol
% -------------------------

% Olor almendra → ingerible
clase_hongo(F, 'almendra', _, 'ingerible') :-
    nonvar(F).

% Olor anis → ingerible
clase_hongo(F, 'anis', _, 'ingerible') :-
    nonvar(F).

% Olor ninguno + praderas → venenoso
clase_hongo(_, 'ninguno', 'praderas', 'venenoso').

% Olor ninguno + forma conica → venenoso
clase_hongo('conica', 'ninguno', _, 'venenoso').

% Olor ninguno + formas frecuentes → ingerible
clase_hongo(F, 'ninguno', H, 'ingerible') :-
    member(F, ['acampanada', 'abotonada', 'chata', 'convexa', 'abultada']),
    H \= 'praderas',
    H \= 'bosque'.

% Caso específico observado
clase_hongo('abotonada', 'ninguno', 'bosque', 'ingerible').

% Prioridad a hechos explícitos
clase_hongo(F, O, H, 'ingerible') :-
    (ingerible(F, O) ; ingerible(F, O, H)), !.

clase_hongo(F, O, H, 'venenoso') :-
    (venenoso(F, O) ; venenoso(F, O, H)), !.

% Fallback
clase_hongo(_, _, _, 'desconocido').

% -------------------------
% MAIN (ejecución automática)
% -------------------------

:- initialization(main).

main :-
    clase_hongo('abultada', 'ninguno', 'cercano', C1),
    writeln(C1),

    clase_hongo('abultada', 'mohoso', 'lo_que_sea', C2),
    writeln(C2),

    clase_hongo('convexa', 'almendra', 'bosque', C3),
    writeln(C3),

    clase_hongo('conica', 'ninguno', 'bosque', C4),
    writeln(C4),

    clase_hongo('x', 'y', 'z', C5),
    writeln(C5),

    halt.