%% new latex class [2019/06/06 A FontAwesome two columns LaTeX CV Class]
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{faresume}

%% Enhirited Class and required packages
\LoadClass[a4paper]{article}

\RequirePackage[hmargin=1.5cm,left=.3cm,vmargin=.2cm,top=.4cm]{geometry}
\RequirePackage[hidelinks]{hyperref}
\RequirePackage[utf8]{inputenc}
\RequirePackage[default]{lato}
\RequirePackage[T1]{fontenc}
\RequirePackage{fontawesome}
\RequirePackage{graphicx}
\RequirePackage{setspace}
\RequirePackage{titlesec}
\RequirePackage{titling}
\RequirePackage{xcolor}
\RequirePackage{ifthen}
\RequirePackage{calc}

%% Font setting definitions
\newcommand{\authorfont}        {\huge\bfseries}
\newcommand{\titlefont}         {\large\bfseries}
\newcommand{\blocktitlefont}    {\large}
\newcommand{\sectiontitlefont}  {\normalsize\bfseries}
\newcommand{\contentfont}       {\normalsize\fontseries{l}\selectfont}
\newcommand{\tagsfont}          {\scriptsize\scshape}

%% DONT number pages!
\pagenumbering{gobble}

%% DONT use hyphenation
\tolerance=1
\hyphenpenalty=10000
\hbadness=10000

%% Color definitions (help yourself at https://latexcolor.com/)
\definecolor{page-color}{HTML}{F6F2E3}
\definecolor{default-color}{HTML}{000000}
\definecolor{primary-color}{HTML}{ac7331}
\definecolor{secondary-color}{HTML}{848484}
\definecolor{dark-gray-color}{HTML}{444444}
\definecolor{light-gray-color}{HTML}{BFBFBF}

%% Nice readable background
\pagecolor{page-color}

%% Length definitions
\newlength{\headerheigth}
\newlength{\headerwidth}
\newlength{\headersep}
\setlength{\headerheigth}           {2cm}
\setlength{\headerwidth}            {0.72\textwidth}
\setlength{\headersep}              {.5cm}

\newlength{\profilepicturewidth}
\newlength{\titlesectionwidth}
\setlength{\profilepicturewidth}    {0.20\headerwidth}
\setlength{\titlesectionwidth}      {0.60\headerwidth}

\newlength{\leftcolumnwidth}
\newlength{\rightcolumnwidth}
\newlength{\contactsectionwidth}
\setlength{\leftcolumnwidth}        {0.68\textwidth}
\setlength{\rightcolumnwidth}       {0.38\textwidth}
\setlength{\contactsectionwidth}    {0.90\rightcolumnwidth}

\newlength{\contentindent}
\newlength{\contentwidth}
\newlength{\contentsep}
\setlength{\contentindent}          {.5cm}
\newcommand{\contentwidthratio}     {0.90}
\setlength{\contentsep}             {.2cm}

\newlength{\myrulefill}

%% For simplicity's sake!
\newcommand{\fawesomize}[3][t]{
    \makebox[\contentindent][c]{#2}
    \begin{minipage}[#1]{\contentwidth-\contentindent}
        #3
    \end{minipage}
    % \parbox[#1]{}
}

\newcommand{\squareitem}[2][t]{
    \fawesomize[#1]{{\tiny\faStop}}{#2}
}

% BUG invisible characters?
\newcommand{\link}[3][\color{primary-color}]{{#1\href{#2}{#3}}}

%% Header definitions
\newcommand{\profilepicture}[2][{0 0 0 0}]{
    \newcommand{\theprofilepicture}[0]{
    \begin{minipage}[c]{\profilepicturewidth}
        \includegraphics[trim=#1,clip,width=\textwidth]{#2}
    \end{minipage}
    \hspace{\contentindent}
    }
}
\newcommand{\birth}[2][EN]{
    \ifthenelse{\equal{#1}{FR}}
    {
        \newcommand{\thebirth}[0]{N\'e le #2}
    }
    {
        \newcommand{\thebirth}[0]{Date of birth #2}
    }
}
\newcommand{\email}[1]{\newcommand{\themail}[0]{
    \link[\color{secondary-color}]{mailto:#1}{#1}}
}
\newcommand{\address}[1]{\newcommand{\theaddress}[0]{#1}}
\newcommand{\phone}[1]{\newcommand{\thephone}[0]{#1}}
\newcommand{\website}[1]{\newcommand{\thewebsite}[0]{
    \link[\color{secondary-color}]{https://#1}{#1}}
}

%% Header Layout: [ Pic  Title	  | Contact ]
\renewcommand{\maketitle}{
    \begin{minipage}[b][\headerheigth]{\headerwidth}
        \ifthenelse{\NOT\isundefined{\theprofilepicture}}
        {
            \theprofilepicture
        }
        {
            \setlength{\titlesectionwidth}{\leftcolumnwidth}
        }
    	\begin{minipage}[t][0cm][c]{\titlesectionwidth}
            {\color{default-color}\authorfont\theauthor}
            \par\setstretch{1.3}
            {\color{primary-color}\titlefont\thetitle}
    	\end{minipage}
    \end{minipage}\hfill
    \begin{minipage}[c][\headerheigth]{\contactsectionwidth}
        \color{secondary-color}\contentfont
        \setlength{\contentwidth}{\contentwidthratio\textwidth}
        \setstretch{1.2}
        \par\fawesomize{\faCalendar}{\thebirth}
        \par\fawesomize[c]{\faEnvelope}{\themail}
        \par\fawesomize{\faMapMarker}{\theaddress}\\
        \par\fawesomize{\faPhoneSquare}{\thephone}
        \par\fawesomize[c]{\faLink}{\thewebsite}
    \end{minipage}
    \par
    \ifthenelse{\isundefined{\theprofilepicture}}
    {
        \vspace{2\headersep}
    }
    {
        \vspace{\headersep}
    }
}

%% Body Layout:   [    COLUMN1    | COLUMN2 ]
\newenvironment{column}[1][\textwidth]
{\begin{minipage}[t]{#1}}
{\end{minipage}\hfill}

%% Titles format and spacing definitions
% \titleformat{command}     % \titlespacing{command}
% [shape]                   % {left}
% {format}                  % {before-sep}
% {label}                   % {after-sep}
% {sep}                     % [right-sep]
% {before-code}
% [after-code]

%% section
\titleformat{\section}
{\color{primary-color}\blocktitlefont}
{}{0cm}{}
\titlespacing{\section}
{0cm}{\contentsep}{0.5\contentsep}

%% subsection
\titleformat{\subsection}[runin]
{\color{default-color}\sectiontitlefont}
{}{0cm}{}
\titlespacing{\subsection}
{0cm}{0cm}{3pt}[\contentsep]

%% New content
% Type [free, job, degree, project, lang, asset]
% ex: [free]:  {details}
%     [job,degree]:
%              {Position}{Company}{Place}{Period}{Details}
%     [project]:
%              {Project}[Company]{Tags}{Period}{Details}
%     [lang]:  {Skill}{Mastery}{Details}
%     [asset]: {Asset}{Details}
\newcommand{\addcontent}[6][free]{
    \hspace{\contentindent}
    \setlength{\contentwidth}{\contentwidthratio\textwidth}
    \begin{minipage}{\contentwidth}
        \ifthenelse{\NOT\equal{#1}{free}}
        {
            \subsection{#2}
            %% Position (Skill)
            \ifthenelse{\equal{#1}{asset}\AND
                        \NOT\equal{#3}{}\AND
                        \NOT\equal{#4}{inlined}\OR
                        \equal{#1}{lang}}
            {
                %% Breaking the subsection's runin
                \hfill\\
            }
            {
                %% else put nothing in this paragraph
            }
        }
        {
            %% else put nothing in this paragraph
        }
        \ifthenelse{\equal{#1}{job}\OR\equal{#1}{degree}}
        {
            %% / Company Place
            %% Period
            {\contentfont / {\color{primary-color} #3} {\color{dark-gray-color}#4}}
            \par{\color{secondary-color}\contentfont #5}
            \par\vspace{0.6\contentsep}
        }
        {
            \ifthenelse{\equal{#1}{project}}
            {
                %% Tags
                \ifthenelse{\NOT\equal{#3}{}}
                {
                    {\contentfont / {\color{primary-color} #3}}
                }
                {
                    %% else put nothing in this paragraph
                }
                \hfill{\tagsfont #4}
                \par{\color{secondary-color}\contentfont#5}
                \par\vspace{0.6\contentsep}
            }
            {
                %% else put nothing in this paragraph
            }
        }
        \begin{minipage}{\textwidth}
            \ifthenelse{\equal{#1}{lang}}
            {
                %% Mastery (rule)
                \begin{minipage}{\contentwidthratio\contentwidth}
                    \setlength{\myrulefill}{\textwidth}
                    \addtolength{\myrulefill}{-#3\textwidth}
                    {\color{primary-color}\rule{#3\textwidth}{4pt}}
                    \hspace{-.13cm}
                    {\color{light-gray-color}\rule{\myrulefill}{4pt}}
                \end{minipage}
            }
            {
                %% else put nothing in this paragraph
            }
            %% Details (This paragraph is for everyone)
            \ifthenelse{\equal{#1}{free}}%
            {
                {\color{secondary-color}\contentfont{#2}}
            }
            {
                \ifthenelse{\equal{#1}{asset}}
                {
                    {\color{secondary-color}\contentfont{#3}}
                }
                {
                    \ifthenelse{\equal{#1}{lang}}
                    {
                        {\color{secondary-color}\contentfont{#4}}
                    }
                    {
                        \ifthenelse{\equal{#1}{degree}\OR
                                    \equal{#1}{job}\OR
                                    \equal{#1}{project}}
                        {
                            {\color{secondary-color}\contentfont{#6}}
                        }
                        {
                            %% else put nothing in this paragraph
                        }
                    }
                }
            }
        \end{minipage}
    \end{minipage}
    %% Spacing
    \ifthenelse{\equal{#1}{job}\OR\equal{#1}{degree}}%\OR\equal{#1}{project}}
    {
        \vspace{-0.5\contentsep}
    }
    {
        \vspace{0.5\contentsep}
    }
}

\newcommand{\addblock}[2]{
    \section{\fawesomize{#1}{\mbox{#2}}}
}
