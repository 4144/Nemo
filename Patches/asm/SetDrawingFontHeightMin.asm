; Copyright (C) 2021-2022 Andrei Karas (4144)
;
; Patch is licensed under a
; Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
;
; You should have received a copy of the license along with this
; work. If not, see <http://creativecommons.org/licenses/by-nc-nd/4.0/>.
;

mov eax, dword ptr [esp + 8]
cmp eax, value
jge skip

mov dword ptr [esp + 8], value

skip:
