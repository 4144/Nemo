; Copyright (C) 2021-2023 Andrei Karas (4144)
;
; Patch is licensed under a
; Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
;
; You should have received a copy of the license along with this
; work. If not, see <http://creativecommons.org/licenses/by-nc-nd/4.0/>.
;

cmp dword ptr [{reg} + {field}], {value}
%inshex stolenCode
jmp continueAddr
