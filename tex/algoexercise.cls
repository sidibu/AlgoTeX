% FoP and AuD Exercise template class
% Author: Ruben Deisenroth
\def\fileversion{2.2.7}
\def\filedate{2022/08/27}

% Sets the LaTeX version for the package to work.
\NeedsTeXFormat{LaTeX2e}

% LateX 3 Syntax
\RequirePackage{expl3}

% Identification of the class and its date and version.
\ProvidesExplClass{algoexercise}{\filedate}
{\fileversion}{Exercise sheet template class for FoP and AuD}

% Used by CI/CD to inject options
\IfFileExists{options.cfg}{\input{options.cfg}}{}

\RequirePackage[minted_workaround,caption_workaround]{algo-common}

% Packages that need to be loaded before TUDA-Exercise Class
\PassOptionsToPackage{bookmarksnumbered}{hyperref} % Nummerierte Bookmarks

\prop_new:N \g_algo_ex_opts_prop
\bool_gset_true:N \g_algo_ex_corporate_design_bool

\tl_gclear_new:N \g_algoexercise_keys_tl
\tl_gset:Nn \g_algoexercise_keys_tl {
    boxarc .code:n = \PassOptionsToPackage{\CurrentOption}{algo-common},
    dark_mode .code:n = \PassOptionsToPackage{\CurrentOption}{algo-common},
    load_common .bool_gset:N = \g_algo_ex_load_common_bool,
    load_common .initial:n = false,
    load_common . default:n = true,
    fancy_row_color .code:n = \PassOptionsToPackage{\CurrentOption}{algo-common},
    shell_escape .code:n = \PassOptionsToPackage{\CurrentOption}{algo-common},
    manual_term .bool_gset:N = \g_manual_term_bool,
    manual_term .initial:n = false,
    manual_term .default:n = true,
    maxdifficulty .code:n = \prop_gput:Nnn \g_algo_ex_opts_prop {maxdifficulty} {#1},
    maxdifficulty .initial:n = {3},
    maxdifficulty .default:n = {3},
    inlineshortcut .code:n = \prop_gput:Nnn \g_algo_ex_opts_prop {inlineshortcut} {#1},
    inlineshortcut .initial:n = {java},
    inlineshortcut .default:n = {java},
    logopath .code:n = \prop_gput:Nnn \g_algo_ex_opts_prop {logopath} {#1},
    logopath .initial:n = {tuda_logo},
    logopath .default:n = {tuda_logo},
    showpoints .bool_gset:N = \g_algo_ex_show_points_bool,
    showpoints .initial:n = true,
    showpoints .default:n = true,
    % corporatedesign .bool_gset:N = \g_algo_ex_corporate_design_bool,
    % corporatedesign .initial:n = false,
    % corporatedesign .default:n = true,
    hidepoints .bool_gset_inverse:N = \g_algo_ex_show_points_bool,
    hidepoints .initial:n = false,
    hidepoints .default:n = true,
    showtotalpoints .bool_gset:N = \g_algo_ex_show_total_points_bool,
    showtotalpoints .initial:n = true,
    showtotalpoints .default:n = true,
    hidetotalpoints .bool_gset_inverse:N = \g_algo_ex_show_total_points_bool,
    hidetotalpoints .initial:n = false,
    hidetotalpoints .default:n = true,
    titleprefix .tl_gset:N = \g_algo_ex_title_prefix_tl,
    titleprefix .default:n = {},
    titleprefix .initial:n = {},
    template .code:n = \prop_gput:Nnn \g_algo_ex_opts_prop {template} {#1},
    template .default:n = {},
    template .initial:n = {},
    fop .meta:n = {template=fop},
    aud .meta:n = {template=aud},
}
% Additional Class Options
\exp_args:Nno \keys_define:nn {ptxcd/exercise} { \g_algoexercise_keys_tl }
\exp_args:Nno \keys_define:nn {algo/exercise} { \g_algoexercise_keys_tl }
% Compatibility with older versions (We can't use version check makros before loading the class)
\exp_args:Nno \keys_define:nn {TUDa/pub} { \g_algoexercise_keys_tl }
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{tudaexercise}}
\ProcessOptions\relax
% \ProcessKeysOptions{algo/exercise}

\bool_if:NTF \g_algo_ex_corporate_design_bool {
    \LoadClass[
        colorback=false,
        points=true,
        footsepline=.5pt,
        parskip,
        color=3b,
        T1,
    ]{tudaexercise}
}{
    \DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
    \ProcessOptions\relax
    \LoadClass[12pt, a4paper]{article}
}

\RequirePackage{algo-snippets}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins}
\RequirePackage{enumitem}
\RequirePackage{amssymb}
\RequirePackage{caption}
\RequirePackage{cprotect}
\RequirePackage{subcaption}
\RequirePackage{nameref}
\RequirePackage{fontawesome5}

\ifPDFTeX
    \RequirePackage[utf8]{inputenc}
\fi
\RequirePackage{csquotes}
\RequirePackage[german, ngerman]{babel}

% \RequirePackage{parskip}

% \RequirePackage{pifont}

%%--Document Properties--%%
% Datesubject
\tl_gclear_new:N \datename
\tl_gset:Nn \datename {Datum}
\tl_gclear_new:N \printDate
\renewcommand*{\date}[1]{
    \tl_gset:Nn \@date {#1}
    \tl_if_empty:NF \@date {\tl_gset:Nn \printDate {\textsf{\textbf{\datename{}:~}}\@date}}
}

\tl_gclear_new:N \printAuthor
\renewcommand*{\author}[1]{
    \seq_gset_split:Nnn \g_ptxcd_author_seq {\and} {#1}
    \seq_if_empty:NF \g_ptxcd_author_seq {\tl_gset:Nn \printAuthor {\int_compare:nTF{\seq_count:N \g_ptxcd_author_seq > 1}{Übungsblattbetreuer}{Übungsblattbetreuer}:~\hfill\seq_use:Nnnn \g_ptxcd_author_seq {~\authorandname{}~} {,~} {~\authorandname{}~}\par}}
}

\renewcommand*{\sheetnumber}[1]{\tl_gset:Nx \g_ptxcd_ex_sheetnum_tl {#1}}
% Sheet number
\newcommand*{\getSheetnumber}{
    \padzeroes{
        \IfTudaciVersionAtLeastTF{3.0}{
            \g_ptxcd_ex_sheetnum_tl
        }{
            \g_TUDa_ex_sheetnum_tl
        }
    }
}
\newcommand*{\printSheetNumber}{\tl_if_empty:NF \g_ptxcd_ex_sheetnum_tl {\sffamily\textbf{Übungsblatt\space{}Nummer:}\space\padzeroes{\getSheetnumber}}}

% Sheet Version
\DeclareDocumentProperty{version}[1.0][v*]

% Short title
\newcommand*{\getShorttitle}{
    \IfTudaciVersionAtLeastTF{3.0}{
        \g_ptxcd_shorttitle_tl
    }{
        \g_TUDa_shorttitle_tl
    }
}

% Semester
\DeclareDocumentProperty{semester}[][*]

% Fachbereich
\DeclareDocumentProperty{fachbereich}[][\textsf{\textbf{Fachbereich:~}*}]

% Fach
\DeclareDocumentProperty*{fach}[][\textsf{\textbf{Fach:~}*}]

% Supervisor (Sheet maintainer)
\DeclareDocumentProperty{supervisor}[][Übungsblatt-Betreuer:\hfill *]

% Topics
\DeclareDocumentProperty{topics}[][Themen:\hfill *]

% Slides
\DeclareDocumentProperty{slides}[][Relevante~Foliensätze:~\hfill *]

% Duedate
\DeclareDocumentProperty{duedate}[][Abgabe~der~Hausübung:\hfill *]

% Dozent
\DeclareDocumentProperty{dozent}[][\textsf{\textbf{Dozent:~}*}]

%%--Templates--%%
\str_case_e:nnTF {\prop_item:Nn \g_algo_ex_opts_prop {template}} {
    {fop} {
        % \setkomavar{subject}[Funktionale~und~objektorientierte~Programmierkonzepte]{FoP}
        \fach[Funktionale~und~objektorientierte~Programmierkonzepte]{FoP}
        \tl_gset:Nn \g_algo_ex_title_prefix_tl {\getFach*{}}
    }
    {aud} {
        % \setkomavar{subject}[Algorithmen~und~Datenstrukturen]{AuD}
        \fach[Algorithmen~und~Datenstrukturen]{AuD}
        \tl_gset:Nn \g_algo_ex_title_prefix_tl {\getFach*{}}
    }
} {%⟨true code ⟩
    \bool_if:NF \g_algo_ex_corporate_design_bool  {
        \RequirePackage[
            left=2.5cm, right=2.5cm, top=3.5cm, bottom=2cm,
            headheight=1cm, headsep=1.5cm,
            footnotesep=0.3cm, footskip=1cm]{geometry}
    }
    \RequirePackage{graphicx}

    \bool_if:NF \g_algo_ex_corporate_design_bool  {
        \RequirePackage{fancyhdr}

        \pagestyle{fancy}
        \fancyhf{}
        \fancyhead[L]{\usekomavar*{subject}}
        \fancyhead[R]{\@title}
        \fancyfoot[C]{\thepage}
    }
} {%⟨false code ⟩

}

\newcommand\algoexercise@stars[2]{
    \newcount\currentstar
    \currentstar=0
    \loop \ifnum \currentstar < #2
    \ifnum
        \currentstar < #1 \ding{72}
    \else
        \ding{73}
    \fi
    \advance \currentstar 1 \repeat
}

\clist_new:N \g_rubos_ex_term_order_clist
\clist_gset:Nn \g_rubos_ex_term_order_clist {printSemester,printContributor,printVersion,quad,quad,printDate,printFachbereich}
\newcommand*{\termOrder}[1]{\tl_gset:Nn \g_rubos_ex_term_order_clist {#1}}

\tl_gclear_new:N \g_ptxcd_ex_term_style_tl
\newcommand*{\termStyle}[1]{\tl_gset:Nn \g_ptxcd_ex_term_style_tl {#1}}
\termStyle{left-right}
\seq_gclear_new:N \g_ptxcd_term_left_seq
\seq_gclear_new:N \g_ptxcd_term_right_seq
\newcommand{\termLeft}[1]{
    \clist_gclear_new:N \g_ptxcd_temp_clist
    \tl_gset:Nn \g_ptxcd_temp_clist {#1}
    \clist_map_inline:Nn \g_ptxcd_temp_clist {
        \tl_if_empty:cF {##1} {
            \seq_put_right:Nn \g_ptxcd_term_left_seq {\use:c {##1}}
        }
    }
}
\newcommand{\termRight}[1]{
    \clist_gclear_new:N \g_ptxcd_temp_clist
    \tl_gset:Nn \g_ptxcd_temp_clist {#1}
    \clist_map_inline:Nn \g_ptxcd_temp_clist {
        \tl_if_empty:cF {##1} {
            \seq_put_right:Nn \g_ptxcd_term_right_seq {\use:c {##1}}
        }
    }
}

\termStyle{left-right-manual}
% \termOrder{printAuthor,printSheetNumber,printGroupNumber,printContributor,printVersion,,printSemester,printDate,printFachbereich}
\termLeft{}
\termRight{}
\term{
    \printAuthor{}
    \printSemester{}\hfill\printVersion{}\\
    \printTopics{}\\
    \printSlides{}\\
    \printDuedate{}
}

\renewcommand*{\@maketitle}{%
    % \maketerm{}% Might Move Term Creation here soon
    \global\@topnum=\z@
    \setparsizes{\z@}{\z@}{\z@\@plus 1fil}\par@updaterelative
    \vspace*{-\dim_eval:n {
            \headheight
            -\c_ptxcd_largerule_dim -\c_ptxcd_rulesep_dim
            +\headsep
            +\ht\strutbox
            +\p@
        }
    }
    \par
    \nointerlineskip
    \begingroup
    \setlength{\fboxsep}{\z@}
    \bool_if:NT \g_ptxcd_colorback_bool {\colorbox{accentcolor}}{\parbox[t]{\linewidth}{
            \rule{0pt}{\bool_if:NTF \g_ptxcd_smalltitle_bool {.25} {.5}\c_ptxcd_logoheight_dim}
            \par\nointerlineskip
            \raisebox{-\height}{%
                \begin{minipage}[t]{\dimexpr\linewidth-2.2\c_ptxcd_logoheight_dim-1ex}
                    \bool_if:NT \g_ptxcd_colorback_bool  {
                        \begin{addmargin}{3mm}}
                            \raggedright
                            \bool_if:NT \g_ptxcd_colorback_bool {\color{textonaccentcolor}}
                            \tl_if_empty:NF \@titlehead {\usekomafont{titlehead}{\@titlehead\par}}
                            \leavevmode\usekomafont{title}%
                            {\usekomafont{title}\bool_if:NTF \g_ptxcd_smalltitle_bool {\LARGE} {\huge} {\tl_if_blank:nF {\g_algo_ex_title_prefix_tl} {\g_algo_ex_title_prefix_tl\par}\@title\par}}%
                            \vskip 1em
                            \bool_if:NF \g_ptxcd_ex_compatibility_bool
                            {
                                {\ifx
                                        \@subtitle\@empty
                                    \else
                                        \usekomafont{subtitle}\@subtitle\par
                                    \fi
                                }%
                                \gdef\@subtitle{}
                                \vskip .5em
                            }
                            % Standart Author Position
                            % {
                            %   \xdef\@author {\@author}
                            %   \ifx\@author\@empty\else\usekomafont{author}\@author\par\fi
                            % }
                            % \usekomafont{author}Rückfragen~zu~diesem~Übungsblatt~vorzugsweise~im~\\~moodle-Forum~zu~diesem~Blatt!\par
                            \vskip .5em
                            \bool_if:NTF \g_ptxcd_colorback_bool {
                        \end{addmargin}
                    } {\par}
                \end{minipage}
            }
            \tl_if_empty:NF \g_ptxcd_logofile_tl {
                \hfill\raisebox{\dim_eval:n {
                        \bool_if:NTF \g_ptxcd_colorback_bool
                        {-\height}
                        {-.9\c_ptxcd_logoheight_dim}
                    }}
                [0pt]
                [\dim_eval:n {
                        \bool_if:NTF \g_ptxcd_smalltitle_bool
                        {\bool_if:NTF \g_ptxcd_colorback_bool {1.15}{1}}
                        {\bool_if:NTF \g_ptxcd_colorback_bool {1.5}{1.3}
                        }\c_ptxcd_logoheight_dim}]
                {\makebox[2.2\c_ptxcd_logoheight_dim][l]{\includegraphics[height=\c_ptxcd_logoheight_dim]{\g_ptxcd_logofile_tl}}}
            }
            \par\medskip
        }
    }
    \par
    \nointerlineskip
    \rule{\linewidth}{\g_ptxcd_titlerule_dim}
    % subtitle fields if not compat
    \exp_args:Nf \tl_if_empty:nF {\seq_use:Nnnn \g_ptxcd_author_seq {~\authorandname{}~} {,~} {~\authorandname{}~}\seq_use:Nnnn \g_ptxcd_ex_sheetnum_tl\@date\g_ptxcd_ex_term_tl\use:c {@subsubtitle}\@subtitle}{
        \par\nointerlineskip
        \bool_if:NT \g_ptxcd_colorback_bool {\colorbox{accentcolor}}{
            \parbox{\linewidth}{
                \begin{minipage}{\linewidth}
                    \bool_if:NT \g_ptxcd_colorback_bool {
                        \color{textonaccentcolor}
                        \begin{addmargin}{3mm}
                            }
                            \null\par
                            % Term
                            \bool_if:NTF \g_manual_term_bool{
                                \g_ptxcd_ex_term_tl
                            }
                            {
                                \str_case_e:nnF {\g_ptxcd_ex_term_style_tl} {
                                    {manual} {
                                        \g_ptxcd_ex_term_tl
                                    }
                                }{
                                    \def\ptxcd_nextsep{}
                                    \bool_gset_true:N \g_tmpa_left_bool
                                    \clist_map_inline:Nn \g_rubos_ex_term_order_clist {
                                        % Process different term Styles
                                        \str_case_e:nnF {\g_ptxcd_ex_term_style_tl} {
                                            {left} {
                                                \tl_if_empty:cF {##1} {
                                                    \seq_put_right:cn {\bool_if:nTF \g_tmpa_left_bool {g_ptxcd_term_left_seq} {g_ptxcd_term_right_seq}} {\use:c {##1}}
                                                }
                                            }
                                            {center} {
                                                \tl_if_empty:cF {##1} {
                                                    \seq_put_right:cn {\bool_if:nTF \g_tmpa_left_bool {g_ptxcd_term_left_seq} {g_ptxcd_term_right_seq}} {\use:c {##1}}
                                                }
                                            }
                                            {left-right} {
                                                \tl_if_empty:cF {##1} {
                                                    \seq_put_right:cn {\bool_if:nTF \g_tmpa_left_bool {g_ptxcd_term_left_seq} {g_ptxcd_term_right_seq}} {\use:c {##1}}\bool_set:Nn \g_tmpa_left_bool {!\g_tmpa_left_bool}
                                                }
                                            }
                                            {left-right-manual} {
                                                % Do Nothing lol
                                            }
                                        }
                                        {
                                            \ClassError{rubos_tuda_template}{Unknown Term style Option: \use:c {\g_ptxcd_ex_term_style_tl}}{Available options are: left, center, left-right (default)}
                                        }
                                    }
                                    % Left Side
                                    \begin{minipage}[t]{\seq_if_empty:NF {\g_ptxcd_term_right_seq}{.6}\linewidth}
                                        \str_if_eq:eeT{\g_ptxcd_ex_term_style_tl} {center} {\centering}
                                        \seq_use:Nnnn \g_ptxcd_term_left_seq {\mbox{}\par} {\mbox{}\par} {\mbox{}\par}
                                        \gdef\ptxcd_nextsep{\par}
                                    \end{minipage}
                                    \seq_if_empty:NF {\g_ptxcd_term_right_seq}{
                                        \begin{minipage}[t]{.4\linewidth}
                                            \raggedleft
                                            \begin{flushright}
                                                \seq_use:Nnnn \g_ptxcd_term_right_seq {\mbox{}\par} {\mbox{}\par} {\mbox{}\par}
                                            \end{flushright}
                                            \gdef\ptxcd_nextsep{\par}
                                        \end{minipage}
                                    }
                                    % \vspace{-\abovedisplayskip}
                                    \bool_if:nT { !\seq_if_empty_p:N \g_ptxcd_term_left_seq || !\seq_if_empty_p:N \g_ptxcd_term_right_seq } {
                                        \vspace*{\lineskip}
                                        \par
                                    }
                                    \tl_if_empty:NF \g_ptxcd_ex_term_tl {\g_ptxcd_ex_term_tl}
                                    % \clist_map_inline:nn {@subtitle, @subsubtitle, g_ptxcd_ex_term_tl} {
                                    %   \tl_if_empty:cF {##1} {\ptxcd_nextsep\use:c {##1}\def\ptxcd_nextsep{\\}}
                                    % }
                                    % \tl_if_empty:NF \g_ptxcd_ex_sheetnum_tl {\ptxcd_nextsep\sheetname\sheetsep\g_ptxcd_ex_sheetnum_tl}
                                }
                            }

                            \bool_if:NT \g_ptxcd_colorback_bool {
                        \end{addmargin}
                    }
                \end{minipage}
                \vspace*{\dp\strutbox}
            }
        }
        \par\nointerlineskip
        \rule{\linewidth}{\g_ptxcd_titlerule_dim}
    }
    \par
    \bool_if:NT  \g_ptxcd_headontitle_bool {
        \if@twoside
            \box_use:N \g_ptxcd_ex_headline_odd_box
        \else
            \box_use:N \g_ptxcd_ex_headline_oneside_box
        \fi
        \par
        \rule{\linewidth}{\g_ptxcd_titlerule_dim}
        \par
    }
    \endgroup
    % \vskip 2em
    \ConfigureHeadline{}
}%

\prg_new_conditional:Nnn \__ptxcd_if_corporatedesign: {T,F,TF} {
    \bool_if:NTF \g_algo_ex_corporate_design_bool {
        \prg_return_true:
    } {
        \prg_return_false:
    }
}

\cs_set_eq:NN\IfCorporateDesignT \__ptxcd_if_corporatedesign:T
\cs_set_eq:NN\IfCorporateDesignF \__ptxcd_if_corporatedesign:F
\cs_set_eq:NN\IfCorporateDesignTF \__ptxcd_if_corporatedesign:TF

\IfCorporateDesignT{
    % Discover tudaci-Version
    \exp_args:NNnx \seq_set_split:Nnn \g_tuda_version_seq { ~ } { \use:c {ver@tudaexercise.cls} }
    \tl_set:Nx \g_tudaci_version_tl { \seq_item:Nn \g_tuda_version_seq { 2 } }
    \tl_set:Nx \g_tudaci_version_tl {\tl_tail:N \g_tudaci_version_tl}
    \regex_replace_once:nnN { [a-z] } { } \g_tudaci_version_tl

    \newcommand{\getTudaciVersion}[1]{
        \tl_use:N \g_tudaci_version_tl
    }
    \newcommand{\IfTudaciVersionAtLeastTF}[3]{
        \fp_compare:nTF {\getTudaciVersion{} >= #1}{#2}{#3}
    }
    \newcommand{\IfTudaciVersionBetweenTF}[4]{
        \fp_compare:nTF {#1<=\getTudaciVersion{}<=#2}{#3}{#4}
    }

    % Compatibility with newer TUDA-Versions
    \IfTudaciVersionAtLeastTF{3.12}{
        \clist_map_inline:nn {vues,vue,vueaufgabe,hue,hueaufgabe,hueteilaufgabe} {
            \bool_new:c	{g__ptxcd_ruled_#1_bool}
            \bool_gset_true:c {g__ptxcd_ruled_#1_bool}
        }
    }{}
}

\IfDarkModeT{
    \IfTudaciVersionAtLeastTF{3.12}{
        \IfFileExists{tuda_logo_inverted.pdf}{\tl_gset:Nn \g_ptxcd_logofile_tl {tuda_logo_inverted.pdf}}{}
    }{
        \IfFileExists{tuda_logo_inverted.pdf}{\tl_gset:Nn \g_TUDa_logofile_tl {tuda_logo_inverted.pdf}}{}
    }
}

\IfCorporateDesignT{
    % Custom Headline Style
    \IfTudaciVersionAtLeastTF{3.0}{
        \clist_map_inline:nn {odd, even, oneside} {
            \keys_define:nn {ptxcd/exercise/headline} {
                #1 .choice:,
                #1 / title-name-id .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {
                    \g_ptxcd_shorttitle_tl
                    \par
                    \StudentName
                    \StudentID
                },
                #1 / title-name .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {
                    \g_ptxcd_shorttitle_tl\par
                    \smallskip
                    \StudentName
                },
                #1 / title .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {\g_ptxcd_shorttitle_tl},
                #1 / fulltitle-centered .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {
                    \centering
                    \textbf{\textsf{\@title}
                    }
                },
                #1 / name-id .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {
                    \StudentName
                    \StudentID
                },
                #1 / name .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {
                    \StudentName
                },
                #1 / algo .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {
                    \textbf{\getFach{}\space{}}
                    im\space\fatsf{\getSemester{}}\space{}
                    bei\space\fatsf{\getDozent{}}\hfill\fatsf{\@title}~--~\g_ptxcd_shorttitle_tl\par
                    \StudentName\StudentID
                },
                #1 / algo-min .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {
                    \textbf{\getFach{}\space{}}
                    im\space\fatsf{\getSemester{}}\space{}
                    bei\space\fatsf{\getDozent{}}\hfill\fatsf{\@title}~--~\g_ptxcd_shorttitle_tl
                },
                % Backwards Compatibility
                #1 / aud .meta:n = {#1 / algo = ##1},
                #1 / aud-min .meta:n = {#1 / algo-min = ##1},
            }
        }
    }{
        \clist_map_inline:nn {odd, even, oneside} {
            \tl_gclear_new:c {g_TUDa_ex_headline_#1_tl}
            \keys_define:nn {TUDa/exercise/headline} {
                #1 .choice:,
                #1 / title-name-id .code:n = \tl_gset:cn {g_TUDa_ex_headline_#1_tl} {
                    \g_TUDa_shorttitle_tl\par
                    \StudentName\StudentID},
                #1 / title-name .code:n = \tl_gset:cn {g_TUDa_ex_headline_#1_tl} {
                    \g_TUDa_shorttitle_tl\par
                    \smallskip
                    \StudentName},
                #1 / title .code:n = \tl_gset:cn {g_TUDa_ex_headline_#1_tl} {\g_TUDa_shorttitle_tl},
                #1 / fulltitle-centered .code:n = \tl_gset:cn {g_TUDa_ex_headline_#1_tl} {\centering\textbf{\textsf{\@title}}},
                #1 / name-id .code:n = \tl_gset:cn {g_TUDa_ex_headline_#1_tl} {\StudentName\StudentID},
                #1 / name .code:n = \tl_gset:cn {g_TUDa_ex_headline_#1_tl} {\StudentName},
                #1 / algo .code:n= \tl_gset:cn {g_TUDa_ex_headline_#1_tl} {
                    \textbf{\usekomavar{subject}\space{}}im\space\fatsf{\getSemester{}}\space{}bei\space\fatsf{\getDozent}\hfill \@title - \g_TUDa_shorttitle_tl\par
                    \StudentName\StudentID
                },
                #1 / algo-min .code:n= \tl_gset:cn {g_TUDa_ex_headline_#1_tl} {
                    \textbf{\usekomavar{subject}\space{}}im\space\fatsf{\getSemester{}}\space{}bei\space\fatsf{\getDozent}\hfill \@title - \g_TUDa_shorttitle_tl
                },
                % Backwards Compatibility
                #1 / aud .meta:n = {#1 / algo = ##1},
                #1 / aud-min .meta:n = {#1 / algo-min = ##1},
                #1 / unknown .code:n = \tl_gset:cn {g_TUDa_ex_headline_#1_tl} {##1}
            }
        }
    }
}

% Stilistische Anpassungen der Task-Environments
\renewcommand*{\taskformat}{\rmfamily\bfseries \thetask{}} % Taskprefix
\renewcommand*{\subtaskformat}{\thesubtask\enskip} % This looks way cleaner
\renewcommand*{\thetask}{%
    H\arabic{task}%
}
\renewcommand*{\thesubtask}{%
    H\arabic{task}.\arabic{subtask}%
}
% Point Formating
\cs_set_eq:NN \__old_pointformat \pointformat
\DeclareDocumentCommand{\pointformat}{O{\g_algo_ex_show_points_bool}m}{
    \bool_if:nTF {#1} {
        \__old_pointformat{#2}
    }{
        \bool_if:NTF \l__ptxcd_points_auto_bool
        \creditformatsum
        \creditformat
        {
            ??\space\PointsName
        }
    }
}
\renewcommand*{\creditformat}[1]{#1}
\renewcommand*{\subtaskformat}{\thesubtask{} :\enskip}

% Section Fonts
\setkomafont{section}{\large\bfseries\sffamily}
\setkomafont{subsection}{\normalsize\bfseries\sffamily}
\setkomafont{subsubsection}{\normalsize\bfseries\sffamily}
% Task Fonts
\setkomafont{task}{\normalfont\large\bfseries}
\setkomafont{subtask}{\normalfont\bfseries}

% #1 Hausübungsnummer
% #2 Hausübungstitel
% #3 Gesamtpunktzahl
% #4 Optional: Punktzahlformat (* wird mit Gesamtpuntzahl replaced)
\DeclareDocumentCommand{\hue}{mmmO{
        Gesamt:~\pointformat[\g_algo_ex_show_total_points_bool]{*}
    }}{
    \tl_clear_new:N \l_algo_ex_hue_totpoints_fp
    \tl_set:Nn \l_algo_ex_hue_totpoints_fp {#3}
    \tl_set:Nn \l_algo_ex_hue_pointformat_tl {#4}
    \regex_replace_all:nnN {\*} {\u{l_algo_ex_hue_totpoints_fp}} \l_algo_ex_hue_pointformat_tl
    \unskip\section*{
		    #1\hfill \l_algo_ex_hue_pointformat_tl
		    \\\textrm{\textit{#2}}
	    }
}

% Compatibility with old Sheets
% #1 - Title
% #2 - Points
\DeclareDocumentCommand{\hueaufgabe}{mm}{
    \task[points=#2]{#1}
}

% Compatibility with old Sheets
% #1 - Title
% #2 - Points
\DeclareDocumentCommand{\hueteilaufgabe}{mm}{
    \subtask[points=#2,title={#1}]{}
}

% Description-list styling.
\SetLabelAlign{parright}{\parbox[t]{\labelwidth}{\raggedleft#1}}
\setlist[description]{style = multiline, leftmargin = 4cm, align = parright,font=\mdseries}

\IfTudaciVersionBetweenTF{3.0}{3.26}{
    \DeclareDocumentEnvironment{subtask*}{om}{
        \begingroup
        \IfNoValueF{#1}{\keys_set:nn {ptxcd/subtask}{#1}}
        \@subtask{#2}
        \tl_gset_eq:NN \g_tmpa_tl \@currentlabel
        \endgroup
        \tl_set_eq:NN \@currentlabel \g_tmpa_tl
    }{}
}{}


\renewcommand*\sectionlinesformat[4]{%
    \parbox{\linewidth}{
        \bool_if:cT {g__ptxcd_ruled_#1_bool} {
            \rule[5\g_ptxcd_titlerule_dim]{\linewidth}{\g_ptxcd_titlerule_dim}\par\nointerlineskip
        }
        \@hangfrom{%
            \hskip #2#3}{
            \tl_if_eq:nnT {#1} {task} {
                \exp_args:No \tl_if_empty:nF {#4}
                {:~}
                \bool_if:NT \l__ptxcd_points_auto_bool {
                    \exp_args:NNx \prop_get:NnN \g__ptxcd_loaded_points_prop {\thetask} \l_ptxcd_tmp_tl
                    \quark_if_no_value:NF \l_ptxcd_tmp_tl {
                        \fp_set:Nn \l_ptxcd_ex_task_points_fp {\l_ptxcd_tmp_tl}
                    }
                }
            }
            #4
            \tl_if_in:nnT {#1} {task} {
                \hfill\tl_if_empty:cTF{l_ptxcd_ex_#1_credit_tl}
                {\pointformat{\fp_to_decimal:c {l_ptxcd_ex_#1_points_fp}}}
                {\creditformat{\tl_use:c {l_ptxcd_ex_#1_credit_tl}}}
            }
            \rule[-\dp\strutbox]{0pt}{\dp\strutbox}\par}\nointerlineskip
        \skip_vertical:n {\ptxcd_titlerule_sep: -\dp\strutbox}
        \bool_if:cT {g__ptxcd_ruled_#1_bool} {\smash{\rule{\linewidth}{\g_ptxcd_titlerule_dim}}}
    }}
