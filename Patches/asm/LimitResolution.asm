; Copyright (C) 2021-2023 Andrei Karas (4144)
;
; Patch is licensed under a
; Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
;
; You should have received a copy of the license along with this
; work. If not, see <http://creativecommons.org/licenses/by-nc-nd/4.0/>.
;

%include CreateWindowExA_params
%include win32_constants

cmp dword ptr [tmpVar], 0
jnz skip

inc dword ptr [tmpVar]

mov eax, dword ptr [esp + dwStyle]
and eax, WS_POPUP
cmp eax, 0
jne skip

cmp dword ptr [esp + {offset}], value
{compare} skip

mov dword ptr [esp + {offset}], value

jmp skip

tmpVar:
long 0

skip:
