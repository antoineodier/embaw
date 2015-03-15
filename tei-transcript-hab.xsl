<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:mets="http://www.loc.gov/METS/"
    xmlns:rdf="http://www.w3.org/TR/2004/REC-rdf-syntax-grammar-20040210/"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:mods="http://www.loc.gov/mods/v3"
    exclude-result-prefixes="tei mets xlink exist rdf" version="1.0">

    <!-- Einbindung der Standard-Templates und Variablen -->
    <xsl:import href="http://diglib.hab.de/rules/styles/param.xsl"/>
    <!--<xsl:import href="http://diglib.hab.de/rules/styles/tei-phraselevel.xsl"/>-->



    <xsl:output encoding="UTF-8" indent="yes" method="html"
        doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

    <xsl:strip-space elements="*"/>
    <xsl:param name="dir">edoc/ed000228</xsl:param>
    <xsl:param name="q"/>
    <xsl:param name="qtype"/>
    <xsl:param name="distype"/>
    <xsl:param name="pvID"/>
    <xsl:param name="footerXML"/>
    <xsl:param name="footerXSL"/>
    <xsl:param name="lokal"/>
    <xsl:param name="markup"/>
    <xsl:variable name="metsfile">
        <xsl:value-of select="concat('http://diglib.hab.de/',$dir,'/mets.xml')"/>
    </xsl:variable>

    <xsl:variable name="smallcase" select="'&#173;'"/>
    <xsl:variable name="uppercase" select="'-'"/>

    <xsl:key name="entity-ref" match="tei:rs[@ref]" use="substring(@ref,2)"/>
		<xsl:key name="term-ref" match="tei:term" use="substring(@ref, 2)" />

	<xsl:template match="*" mode="toc">
		<xsl:apply-templates mode="toc" />
	</xsl:template>

	<xsl:template match="tei:date/tei:note" mode="toc" />

    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <title>WDB</title>
                <link  rel="stylesheet" type="text/css" media="screen" href="http://diglib.hab.de/edoc/ed000228/layout/navigator.css"/>
                <!--<link rel="stylesheet" type="text/css" media="print"
                    href="http://diglib.hab.de/edoc/ed000228/layout/print.css"/>-->
                <script type="text/javascript" src="http://diglib.hab.de/edoc/ed000228/javascript/jquery/jquery-1.11.0.js"></script>
                <script type="text/javascript" src="http://diglib.hab.de/edoc/ed000228/javascript/jquery/functions.js"></script>
                <script src="http://diglib.hab.de/navigator.js" type="text/javascript"></script>
                <script src="http://diglib.hab.de/navigator.js" type="text/javascript"><noscript>please activate javascript to enable wdb functions</noscript></script>
            </head>

            <body>
                <!--  Dokumentkopf -->
                <div id="doc_header">
                    <div id="doc_header_text">Text</div>
                    <hr id="doc_header_line"/>
                    </div>

                <!-- Titel -->
                <div id="caption">
                    <div>
                        <xsl:value-of
                            select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                    </div>
                    <div>
                        <xsl:value-of
                            select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author/tei:name/tei:forename"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of
                            select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author/tei:name/tei:surname"/>
                        <xsl:text> </xsl:text>
                    </div>
                </div>


                <div class="content">
                    <!-- Haupttext -->
                </div>
                <xsl:apply-templates select="tei:TEI/tei:text"/>


                <!-- Textapparat  -->
                <xsl:if test="tei:TEI/tei:text/tei:body/tei:div[@type='annotation'] | tei:TEI/tei:text/tei:body//tei:note[@type='annotation']">
                    <hr/>
                </xsl:if>
                <div id="annotation">
                    <xsl:if test="tei:TEI/tei:text/tei:body/tei:div[@type='annotation'] | tei:TEI/tei:text/tei:body//tei:note[@type='annotation']">
                        <div id="textapparat">Textapparat</div>
                    </xsl:if>
                    <div id="annotation_text">
                        <xsl:choose>
                            <xsl:when
                                test="tei:TEI/tei:text/tei:body//tei:note[@type='textapparat']">
                                <!--  Wenn es eine Einleitung zum Textapparat gibt -->
                                <xsl:value-of
                                    select="tei:TEI/tei:text/tei:body//tei:note[@type='textapparat']"
                                />
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="tei:TEI/tei:text/tei:body/tei:div[@type='annotation']">
                                <!--  Wenn es einen Fussnotenbereich gibt -->
                                <xsl:apply-templates
                                    select="tei:TEI/tei:text/tei:body/tei:div[@type='annotation']"/>
                            </xsl:when>
                            <xsl:otherwise>

                                <!--  andernfalls notes auswerten -->
                                <xsl:for-each
                                    select="tei:TEI/tei:text/tei:body//tei:note[@type='annotation']">
                                    <div>
                                        <a>
                                            <xsl:attribute name="name">
                                                <xsl:text>an</xsl:text>
                                                <xsl:number level="any" format="a"
                                                  count="tei:note[@type ='annotation']"/>
                                            </xsl:attribute>
                                            <a>
                                                <xsl:attribute name="href">
                                                  <xsl:text>#ana</xsl:text>
                                                  <xsl:number level="any" format="a"
                                                  count="tei:note[@type ='annotation']"/>
                                                </xsl:attribute>
                                                <span id="annotation_note">
                                                  <xsl:number level="any" format="a" from="tei:div"
                                                  count="tei:note[@type ='annotation']"/>
                                                </span>
                                                <xsl:text> </xsl:text>
                                            </a>
                                            <xsl:apply-templates/>
                                        </a>
                                    </div>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </div>

                <!-- Kommentare  -->
                <xsl:if test="tei:TEI/tei:text/tei:body//tei:note[@type='footnote']">
                    <hr/>
                </xsl:if>
                <div style="background-color:#EEE;">

                    <xsl:if test="tei:TEI/tei:text/tei:body//tei:note[@type='footnote']">
                        <div
                            style="font-size:13pt;
                    font-family:junicode,sans-serif;
                    color:black;
                    font-weight:600;
                    text-align:left;"
                            >Kommentar</div>
                    </xsl:if>
                    <div
                        style=" position:relative;
                    margin-left:0px;
                    margin-right:0px;
                    margin-top:0px;
                    margin-bottom:0px;
                    font-family:junicode,sans-serif;
                    font-size:11pt;">
                        <xsl:choose>
                            <xsl:when test="tei:TEI/tei:text/tei:body//tei:note[@type='commentar']">
                                <!--  Wenn es eine Einleitung zum Kommentar gibt -->
                                <xsl:value-of
                                    select="tei:TEI/tei:text/tei:body//tei:note[@type='commentar']"/>

                            </xsl:when>
                            <xsl:when
                                test="tei:TEI/tei:text/tei:body/tei:div/tei:note[@type='commentar']">
                                <!--  Wenn es eine Einleitung zum Kommentar gibt -->
                                <xsl:value-of
                                    select="tei:TEI/tei:text/tei:body/tei:div/tei:note[@type='commentar']"
                                />
                            </xsl:when>
                            <xsl:otherwise> </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="tei:TEI/tei:text/tei:body/tei:div[@type='footnotes']">
                                <!--  Wenn es einen Fussnotenbereich gibt -->
                                <xsl:apply-templates
                                    select="tei:TEI/tei:text/tei:body/tei:div[@type='footnotes']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!--  andernfalls notes auswerten -->
                                <xsl:for-each
                                    select="tei:TEI/tei:text/tei:body//tei:note[@type='footnote']">
                                    <div>
                                        <a>
                                            <xsl:attribute name="name">
                                                <xsl:text>fn</xsl:text>
                                                <xsl:number level="any"
                                                  count="tei:note[@type ='footnote']"/>
                                            </xsl:attribute>
                                            <a>
                                                <xsl:attribute name="href">
                                                  <xsl:text>#fna</xsl:text>
                                                  <xsl:number level="any"
                                                  count="tei:note[@type ='footnote']"/>
                                                </xsl:attribute>
                                                <span
                                                  style="font-size:9pt;vertical-align:super;color:red;">
                                                  <xsl:number level="any"
                                                  count="tei:note[@type ='footnote']"/>
                                                </span>
                                            </a>
                                            <xsl:apply-templates/>
                                        </a>
                                    </div>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </div>


                <!-- Bibliographie -->
                <a name="bibliography">
                    <hr style="height:1px;margin:1em 0 1em; 0"/>
                </a>
                <xsl:apply-templates
                    select="tei:TEI/tei:text/tei:back/tei:div[@type='bibliography']"/>

                <!-- footer -->
                <div id="doc_footer">

                    <xsl:choose>
                        <xsl:when
                            test="document($metsfile)//mets:rightsMD[@ID=document($metsfile)//mets:div[@TYPE='bibliography']/@ADMID]/mets:mdRef/@xlink:href">
                            <b>
                                <xsl:text>© </xsl:text>
                                <xsl:for-each select="document($metsfile)//mods:mods/mods:name">
                                    <xsl:if test="position() > 1">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                    <xsl:value-of select="mods:displayForm"/>
                                </xsl:for-each>
                            </b>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                        select="document($metsfile)//mets:rightsMD[@ID=document($metsfile)//mets:div[@TYPE='bibliography']/@ADMID]/mets:mdRef/@xlink:href"
                                    />
                                </xsl:attribute>
                                <img src="http://diglib.hab.de/images/cc-by-sa.png"
                                    alt="image CC BY-SA licence" width="50px" align="right"
                                    hspace="10px"/>
                            </a>

                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="document($metsfile)//mets:rightsMD[@ID=document($metsfile)//mets:div[@TYPE='bibliography']/@ADMID]/mets:mdWrap/mets:xmlData"/>

                        </xsl:otherwise>
                    </xsl:choose>
                </div>

                <!-- Ende main -->
                <div id="info_gloss">
                    <xsl:call-template name="gloss_foot" />
                </div>
                <div id="info_person">
                  <xsl:apply-templates select="//tei:person"/>
                </div>
                <div id="info_place">
                    <xsl:apply-templates select="//tei:place"/>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:body | tei:front">
        <xsl:apply-templates/>
    </xsl:template>

    <!--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        ++++++++++++++++++++++++++++++++++++++++ editionsspezifische Anweisungen ++++++++++++++++++++++++++++++++++++++++++++
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-->

  <!-- mehrspaltiger Text -->

    <xsl:template match="tei:cb">
        <xsl:if test="@n='1'">
            <div class="cb_left">
                <xsl:apply-templates select="following-sibling::tei:p[1]" mode="nachCb"/>
            </div>
        </xsl:if>
        <xsl:if test="@n='2'">
            <div class="cb_right">
                <xsl:apply-templates select="following-sibling::tei:p[1]" mode="nachCb"/>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- preserve-space schützt alle Whitespaces -->

    <xsl:preserve-space elements="*"/>

    <!-- Zeilenumbruch, bzw. Whitespace innerhalb von <w> unterdrücken -->

    <xsl:template match="tei:w">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>

    <xsl:template match="text()[parent::tei:w]">
        <xsl:value-of select="normalize-space()"/>
    </xsl:template>

    <xsl:template match="tei:lb[parent::tei:w]">
       <xsl:text>-</xsl:text><br/>
    </xsl:template>

    <!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->


    <xsl:template match="tei:ex">
        <span class="ex">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:del">
        <span id="del">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:unclear">
        <span id="unclear">[<xsl:apply-templates/>]</span>
    </xsl:template>


    <xsl:template match="//*[@rend='line']">
        <hr/>
            <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:add">
        &lt;<xsl:apply-templates/>&gt;
    </xsl:template>



    <!-- hoch- und tiefgestellte Buchstaben -->
    <xsl:template match="tei:c[@rend='super']">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>

    <xsl:template match="tei:c[@rend='sub']">
        <sub style="color:red;">
            <xsl:apply-templates/>
        </sub>
    </xsl:template>


    <!-- Tabellen -->

    <xsl:template match="tei:table">
        <table>
            <xsl:for-each select="tei:row[@role='label']">

                        <thead>
                                <tr class="label">
                                    <xsl:for-each select="tei:cell[@style='right']">
                                <td style="text-align:right">
                                    <xsl:apply-templates/>
                                </td>
                            </xsl:for-each>
                                    <xsl:for-each select="tei:cell[@style='center']">
                                        <td style="text-align:center">
                                            <xsl:apply-templates/>
                                        </td>
                                    </xsl:for-each>
                                    <xsl:for-each select="tei:cell[@style='left']">
                                        <td style="text-align:left">
                                            <xsl:apply-templates/>
                                        </td>
                                    </xsl:for-each>

                                </tr>
                            </thead>
            </xsl:for-each>
            <tbody>




                <xsl:for-each select="tei:row[following-sibling::tei:milestone[1][@rend='line']]">
                    <tr class="sum">
                        <xsl:for-each select="tei:row">
                            <td class="sum">
                                <xsl:apply-templates/>
                            </td>
                        </xsl:for-each>
                    </tr>
                </xsl:for-each>

                <xsl:apply-templates select="tei:row[@role='data']"/>

            </tbody>
        </table>
    </xsl:template>

    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:if test="@style='right'">
                <xsl:attribute name="style">
                    text-align:right
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@style='center'">
                <xsl:attribute name="style">text-align:center</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:row[@role='data'][not(local-name(following-sibling::*[1])='milestone')]">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    <xsl:template match="tei:row[@role='data'][following-sibling::*[1][@rend='line']]">
        <tr class="sum">
            <xsl:apply-templates/>
        </tr>
    </xsl:template>



    <!--header-->
    <!-- editor, contributer etc. -->
    <xsl:template match="tei:respStmt">
        <xsl:if test="position() != 1">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text> </xsl:text>
        <xsl:value-of select="tei:resp"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="tei:name"/>
    </xsl:template>

    <!-- Front -->

    <xsl:template match="tei:titlePage">
        <p class="content">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:docTitle">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:byline">
        <p class="content">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:imprimatur">
        <p class="content">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:docDate">
        <p class="content">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:docAuthor">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:epigraph">
        <p class="content">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:titlePart">
        <p class="content">
            <xsl:apply-templates/>
        </p>
    </xsl:template>


    <!--body-->
    <!-- main distribution-->
    <xsl:template
        match="tei:div[not(@type='footnotes')] | tei:div1[not(@type='footnotes')] | tei:div2[not(@type='footnotes')] | tei:div3[not(@type='footnotes')]">
        <a>
            <xsl:attribute name="name">
                <xsl:text>div</xsl:text>
                <xsl:number level="any"/>
            </xsl:attribute>
            <xsl:text> </xsl:text>
        </a>
        <!--<xsl:if test="@xml:id[starts-with(.,'org') or starts-with(.,'ue')]">
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:text> </xsl:text>
            </a>
        </xsl:if>-->
        <div>
            <xsl:if test="@type = 'abstract'">
                <xsl:attribute name="style">font-size:smaller;</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!--    Ueberschriften-->

    <xsl:template match="tei:head">

        <xsl:if test="@xml:id[starts-with(.,'org') or starts-with(.,'ue')]">
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:text> </xsl:text>
            </a>
        </xsl:if>
        <a>
            <xsl:attribute name="name">
                <xsl:text>hd</xsl:text>
                <xsl:number level="any"/>
            </xsl:attribute>
            <xsl:text> </xsl:text>
        </a>
        <h2 style="background-color:#EEE;padding:0.3em;margin-top:1em;position:relative;width:100%;">
            <div style="position:relative;width:90%;">
                <xsl:apply-templates/>
            </div>
            <div style="position:absolute;right:1.5em;top:0.2em;font-weight:900;">
                <a href="#">↑</a>
            </div>
        </h2>
    </xsl:template>



    <!-- pysical pages     -->
    <xsl:template match="tei:pb">
        <xsl:variable name="url">
            <!-- convert identifier z.B. drucke_qun-59-9-1_00006 -->
            <xsl:value-of select="$server"/>
            <!-- select type of resource, e.g. mss or drucke -->
            <xsl:value-of select="substring-before(substring(@facs,2),'_')"/>
            <xsl:text>/</xsl:text>
            <!-- select normalised shelfmark -->
            <xsl:value-of select="translate(substring-before(substring-after(substring(@facs,2),'_'),'_'), '_', '/')"/>
            <!-- select Image-No , e.g. 00006  -->
            <xsl:text>/start.htm?distype=imgs&amp;image=</xsl:text>
            <xsl:value-of select="substring-after(substring-after(substring(@facs,2),'_'),'_')"/>
        </xsl:variable>




        <!--    <div class="pagebreak"> // liens vers les facsimilés -->
        <xsl:text> || </xsl:text>

        <xsl:text> [</xsl:text>
        <xsl:if test="@ed">
            <xsl:value-of select="substring(@ed,4)"/>
            <xsl:text>: </xsl:text>
        </xsl:if>

        <xsl:choose>
            <xsl:when test="@facs">
                <a>
                    <xsl:attribute name="href">
                        <xsl:choose>
                            <xsl:when test="@facs">
                                <xsl:value-of select="$url"/>
                                <!--
                                <xsl:if test="starts-with(@facs, '#varia')">
                                    <xsl:text>http://diglib.hab.de/</xsl:text>
                                    <xsl:value-of select="substring-before(substring(@facs,2),'_')"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="substring-before(substring-after(substring(@facs,2),'_'),'_')"/>
                                    <xsl:text>/start.htm?distype=imgs&amp;image=</xsl:text>
                                    <xsl:value-of select="substring-after(substring-after(substring(@facs,2),'_'),'_')"/>
                                </xsl:if>
                                <xsl:if test="starts-with(@facs, '#mss')">
                                    <xsl:text>http://diglib.hab.de/</xsl:text>
                                    <xsl:value-of select="substring-before(substring(@facs,2),'_')"/>
                                    <xsl:text>/start.htm?distype=imgs&amp;image=</xsl:text>
                                    <xsl:value-of select="substring-after(substring-after(substring(@facs,2),'_'),'_')"/>
                                </xsl:if>
                                    -->
                            </xsl:when>
                            <xsl:when test="document($metsfile)//mets:file[@ID=document($metsfile)//mets:div[@ID=$pvID]/mets:fptr/mets:par/mets:area[2]/@FILEID]/mets:FLocat/@xlink:href">
                                <xsl:value-of select="document($metsfile)//mets:file[@ID=document($metsfile)//mets:div[@ID=$pvID]/mets:fptr/mets:par/mets:area[2]/@FILEID]/mets:FLocat/@xlink:href"/>
                                <xsl:text>&amp;image=</xsl:text>
                                <xsl:value-of select="substring-after(substring-after(substring(@facs,2),'_'),'_')"/>
                            </xsl:when>
                            <xsl:when test="starts-with(document($metsfile)//mets:file[@ID=document($metsfile)//mets:div[@ID=$pvID]/mets:fptr/mets:par/mets:area[2]/@FILEID]/mets:FLocat/@xlink:href,'http:')">
                                <xsl:value-of select="document($metsfile)//mets:file[@ID=document($metsfile)//mets:div[@ID=$pvID]/mets:fptr/mets:par/mets:area[2]/@FILEID]/mets:FLocat/@xlink:href"/>
                                <xsl:text>&amp;image=</xsl:text>
                                <xsl:value-of select="substring-after(substring-after(substring(@facs,2),'_'),'_')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$content"/>
                                <xsl:text>?dir=</xsl:text>
                                <xsl:value-of select="$dir"/>
                                <xsl:text>&amp;xml=</xsl:text>
                                <xsl:value-of
                                    select="document($metsfile)//mets:file[@ID=document($metsfile)//mets:div[@ID=$pvID]/mets:fptr/mets:par/mets:area[2]/@FILEID]/mets:FLocat/@xlink:href"/>
                                <xsl:text>&amp;xsl=</xsl:text>
                                <xsl:value-of
                                    select="document($metsfile)//mets:behavior[@STRUCTID=document($metsfile)//mets:div[@ID=$pvID]/mets:fptr/mets:par/mets:area[2]/@ID]/mets:mechanism/@xlink:href"/>
                                <xsl:text>#</xsl:text>
                                <xsl:value-of select="substring(@facs,2)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="target">
                        <xsl:text>display2</xsl:text>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="@n">
                            <xsl:text>Manuscrit: </xsl:text>
                            <xsl:value-of select="@n"/>
                            <xsl:text></xsl:text>
                        </xsl:when>
                        <xsl:when test="@rend">
                            <xsl:value-of select="@rend"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring-after(substring-after(substring(@facs,2),'_'),'_')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </xsl:when>
            <xsl:when test="@rend">
                <xsl:value-of select="@rend"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>-</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:text>] </xsl:text>

    </xsl:template>

    <xsl:template match="tei:linkGrp">
        <xsl:choose>
            <xsl:when test="@type='quote'"> </xsl:when>
        </xsl:choose>

    </xsl:template>

    <!--    Links -->
    <xsl:template match="tei:ref">
        <xsl:param name="caption"/>
        <xsl:choose>
            <xsl:when test="@type='footnote' and $caption != 'true'">
                <a>
                    <xsl:attribute name="name">
                        <xsl:text>fna</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <span style="font-size:9pt;vertical-align:super;color:blue;">
                        <xsl:value-of select="."/>
                    </span>
                </a>
            </xsl:when>




            <!-- Google Books -->
            <xsl:when test="@type='google_books'">
                <a>
                    <xsl:attribute name="href">
                        <xsl:text>javascript:show_annotation_html('</xsl:text>
                        <xsl:value-of select="$dir"/>
                        <xsl:text>','</xsl:text>
                        <xsl:value-of select="@target"/>
                        <xsl:text>',400,600)</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:when test="@type='bibliography'">
                <a>
                    <xsl:if test="starts-with(@target,'#')">
                        <xsl:attribute name="title">
                            <xsl:value-of select="normalize-space(id(substring(@target,2)))"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:attribute name="target">_blank</xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="tei:ptr">
        <xsl:apply-templates/>
        <xsl:choose>
            <xsl:when test="@type='google_books'"> [<a>
                    <xsl:attribute name="href">
                        <xsl:text>javascript:show_annotation_html('</xsl:text><xsl:value-of
                            select="$dir"/><xsl:text>','</xsl:text><xsl:value-of select="@target"
                        /><xsl:text>',400,600)</xsl:text>
                    </xsl:attribute>
                    <xsl:text>Google Books</xsl:text></a>] </xsl:when>
            <xsl:when test="starts-with(@target,'http://')"> [<a>
                    <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
                    <xsl:attribute name="target">_blank</xsl:attribute>
                    <xsl:text>Link</xsl:text>
                </a>] </xsl:when>
            <xsl:when test="@type='opac' "> [<a href="{normalize-space(concat($opac,@cRef))}"
                    target="_blank">Nachweis im OPAC</a>] </xsl:when>
            <xsl:when test="@type='gbv' "> [<a href="{normalize-space(concat($gbv,@cRef))}"
                    target="_blank">Nachweis im GBV</a>] </xsl:when>
            <xsl:when test="@type='GettyThesaurus' "> [<a
                    href="{normalize-space(concat($GettyThesaurus,(substring-after(@target, '#TGN_'))))}"
                    target="_blank">TGN</a>] </xsl:when>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="tei:listBibl">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>


    <xsl:template match="tei:bibl[parent::tei:listBibl]">
        <li>
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:text> </xsl:text>
            </a>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <!-- footnotes, annotations -->

    <!-- Übersetzung als tooltip -->

    <xsl:template match="tei:foreign">
        <xsl:if test="following-sibling::*[1] = following-sibling::tei:note[position() = 1 and @type='translation']">
            <a href="#" class="tooltip">
                    <span class="custom help">
                        <xsl:value-of select="following-sibling::*"/>
                    </span>
                <xsl:apply-templates/></a>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:note[@annotation] | tei:note[@explanation]">
        <a href="#" class="tooltip">
            <span class="custom help">
                <xsl:value-of select="*"/>
            </span>
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <!--<xsl:when test="@type='annotation'">
        <!-\-  in Text integriert, nur Verweis , Fussnotenabschnitt mit foreach generiert -\->
        <a>
            <xsl:attribute name="name">
                <xsl:text>ana</xsl:text>
                <xsl:number level="any" format="a" count="tei:note[@type ='annotation']"/>
            </xsl:attribute>
            <a>
                <xsl:attribute name="href">
                    <xsl:text>#an</xsl:text>
                    <xsl:number level="any" format="a" count="tei:note[@type ='annotation']"
                    />
                </xsl:attribute>
                <xsl:attribute name="title"><xsl:copy-of select="normalize-space(.)"/></xsl:attribute>
                <span style="font-size:9pt;vertical-align:super;color:blue;">

                    <xsl:number level="any" format="a" from="tei:div"
                        count="tei:note[@type ='annotation']"/>
                </span>
            </a>
        </a>
    </xsl:when>-->



    <xsl:template match="tei:note">

        <xsl:param name="caption"/>



        <!--  zwei Typen: entweder Fussnoten am Text- oder Seitenende in einem besonderen Abschnitt oder in den Text integriert -->
        <xsl:choose>



            <xsl:when test="parent::tei:div[@type='footnotes' ]">
                <!--   Fussnoten am Text- oder Seitenende -->
                <div class="footnotes">
                    <a>
                        <xsl:attribute name="name">
                            <xsl:text>fn</xsl:text>
                            <xsl:value-of select="@n"/>
                        </xsl:attribute>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>#fna</xsl:text>
                                <xsl:value-of select="@n"/>
                            </xsl:attribute>
                            <span
                                style="font-size:9pt;vertical-align:super;color:blue;margin-right:0.3em;">
                                <xsl:value-of select="@n"/>
                            </span>
                        </a>
                    </a>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="$caption ='true'">
                <!-- keine Anzeige -->
            </xsl:when>
            <xsl:when test="@type='footnoteX'">
                <!--  noch in Bearbeitung, nicht anzeigen -->
            </xsl:when>
            <xsl:when test="@type='footnote'">
                <!--  in Text integriert, nur Verweis , Fussnotenabschnitt mit foreach generiert -->
                <a>
                    <xsl:attribute name="name">
                        <xsl:text>fna</xsl:text>
                        <xsl:number level="any" count="tei:note[@type ='footnote']"/>
                    </xsl:attribute>

                    <a>
                        <xsl:attribute name="href">
                            <xsl:text>#fn</xsl:text>

                            <xsl:number level="any" count="tei:note[@type ='footnote']"/>

                        </xsl:attribute>
                        <xsl:attribute name="title"><xsl:copy-of select="normalize-space(.)"/></xsl:attribute>
                        <span style="font-size:9pt;vertical-align:super;color:red;">

                            <xsl:value-of select="$caption"/><xsl:number level="any" count="tei:note[@type ='footnote']"/></span>

                    </a>
                </a>
            </xsl:when>
            <xsl:when test="@type='annotation'">
                <!--  in Text integriert, nur Verweis , Fussnotenabschnitt mit foreach generiert -->
                <a>
                    <xsl:attribute name="name">
                        <xsl:text>ana</xsl:text>
                        <xsl:number level="any" format="a" count="tei:note[@type ='annotation']"/>
                    </xsl:attribute>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:text>#an</xsl:text>
                            <xsl:number level="any" format="a" count="tei:note[@type ='annotation']"
                            />
                        </xsl:attribute>
                        <xsl:attribute name="title"><xsl:copy-of select="normalize-space(.)"/></xsl:attribute>
                        <span style="font-size:9pt;vertical-align:super;color:blue;">

                            <xsl:number level="any" format="a" from="tei:div"
                                count="tei:note[@type ='annotation']"/>
                        </span>
                    </a>
                </a>
            </xsl:when>
            <!--<xsl:when test="@place">

                <span style="font-size:9pt; margin-left: 10%;">

                    <xsl:value-of select="."/>
                </span>

            </xsl:when>-->
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>


    </xsl:template>







    <!-- hier erst mal aus    -->
    <xsl:template match="tei:ab"/>




    <!-- closer -->
    <xsl:template match="tei:closer">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- closer -->
    <xsl:template match="tei:opener">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- closer -->
    <xsl:template match="tei:salute">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Namen -->
    <xsl:template match="tei:name">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Datum -->
    <xsl:template match="tei:dateline">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:date">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Grafiken -->
    <xsl:template match="tei:graphic">
        <div style="position:relative; z-index:1;">
            <div style="float:left;">
                <img border="0" style="height:200px; padding-right:15px;">
                    <xsl:attribute name="src">
                        <xsl:value-of select="@url"/>
                    </xsl:attribute>
                </img>

            </div>
        </div>

    </xsl:template>

    <!-- index  erst mal auslassen-->
    <xsl:template match="tei:index"> </xsl:template>

   <!-- <xsl:template match="tei:w">
        <xsl:value-of select="normalize-space(text()[1])"/>
        <xsl:value-of select="normalize-space(text()[2])"/>
    </xsl:template>-->

    <!--  Anker fuer Spruenge im Text -->
    <xsl:template match="tei:anchor">
        <a>
            <xsl:attribute name="name">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:text> </xsl:text>
        </a>
    </xsl:template>
    <!-- lokal ################################################################################################  -->



    <!-- entitaeten -->


    <!--  Textkritik -->

    <xsl:template match="tei:app">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:rdg">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:l">
        <xsl:if test="@xml:id[starts-with(.,'org') or starts-with(.,'ue')]">
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:text> </xsl:text>
            </a>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="@n">
                <span style="position:relative;left:-0.5em;margin-left:2px;font-size:small;"
                        >(<xsl:value-of select="@n"/>)</span>
            </xsl:when>
        </xsl:choose>
        <xsl:apply-templates/>
        <br/>

    </xsl:template>

    <xsl:template match="tei:lg">
        <xsl:if test="@xml:id[starts-with(.,'org') or starts-with(.,'ue')]">
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:text> </xsl:text>
            </a>
        </xsl:if>
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>

    <xsl:template match="tei:quote | tei:q">
        <xsl:if test="@xml:id[starts-with(.,'org') or starts-with(.,'ue')]">
            <a>
                <xsl:attribute name="name"><xsl:value-of select="@xml:id"/></xsl:attribute>
                <xsl:text> </xsl:text>
            </a>
        </xsl:if>&#8222;<i><xsl:apply-templates/></i>&#8220; </xsl:template>

    <xsl:template match="tei:hi | tei:emph | tei:rs/tei:hi">
        <xsl:if test="@xml:id[starts-with(.,'org') or starts-with(.,'ue')]">
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:text> </xsl:text>
            </a>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="@rend ='italics' or @rend ='italic'">
                <span style="font-style:italic;">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend ='underline'">
                <span style="text-decoration:underline">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend ='bold'">
                <span style="font-weight:bold">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend ='oesup'">
                <span>&#58948;</span>
            </xsl:when>
            <xsl:when test="@rend ='uesup'">
                <span>u&#x0364;</span>
            </xsl:when>
            <xsl:when test="@rend='nmakron'">
                <span>&#58844;</span>
            </xsl:when>
            <xsl:when test="@rend ='bold'">
                <span style="font-weight:bold;">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend ='smallCaps' or @rend ='small-caps'">
                <span style="font-variant:small-caps;">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend ='spaced'">
                <span style="letter-spacing:0.2em;">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend ='center'">
                <div style="text-align:center;">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="@rend ='initiale'">
                <span style="font-weight:bold;">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend='aelig'">
                <span>&#230;</span>
            </xsl:when>
            <xsl:when test="@rend='ccedil'">
                <span>&#231;</span>
            </xsl:when>
            <xsl:when test="@rend ='sup'">
                <sup>
                    <xsl:apply-templates/>
                </sup>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- hier ggf ausschalten
       <xsl:template match="tei:lb">
           <xsl:if test="not(@rend) or @rend !='trennstrich'">

               <xsl:text> </xsl:text>
            </xsl:if>
         </xsl:template>-->

    <!--<xsl:template match="tei:lb">
        <xsl:choose>
            <xsl:when test="$lokal != 'orig'">
                <xsl:choose>
                    <xsl:when test="@type='hy'">
                        <span>&#8209;<br/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <br/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="@n">
                        <span style="position:relative;left:-0.5em;font-size:small;">(<xsl:value-of
                                select="@n"/>)</span>
                    </xsl:when>
                    <xsl:otherwise> </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
        <xsl:apply-templates/>
    </xsl:template>-->

	<xsl:template match="tei:p[preceding-sibling::*[1][self::tei:cb]]" />

	<xsl:template match="tei:p[preceding-sibling::*[1][self::tei:cb]]" mode="nachCb">
		<xsl:call-template name="SegP" />
	</xsl:template>

    <xsl:template match="tei:p | tei:seg">
			<xsl:call-template name="SegP" />
    </xsl:template>

	<xsl:template name="SegP">
		<br/>
		<xsl:if test="@xml:id[starts-with(.,'org') or starts-with(.,'ue')]">
			<a>
				<xsl:attribute name="name">
					<xsl:value-of select="@xml:id"/>
				</xsl:attribute>
				<xsl:text> </xsl:text>
			</a>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

    <xsl:template match="exist:match">



        <xsl:variable name="divNo">
            <xsl:number count="tei:div" level="any"/>
        </xsl:variable>

        <xsl:variable name="hitNo">
            <xsl:number level="multiple"/>
        </xsl:variable>

        <xsl:variable name="hitNoAll">
            <xsl:number level="any"/>
        </xsl:variable>
        <a>
            <xsl:attribute name="name">
                <xsl:text>hit</xsl:text>
                <xsl:value-of select="$divNo"/>
                <xsl:text>_</xsl:text>
                <xsl:value-of select="$hitNo"/>
            </xsl:attribute>
            <xsl:text> </xsl:text>
        </a>
        <a>
            <xsl:attribute name="name">
                <xsl:text>hit</xsl:text>
                <xsl:value-of select="$hitNoAll"/>
            </xsl:attribute>
            <xsl:text> </xsl:text>
        </a>
        <span style="background-color:yellow;">
            <xsl:apply-templates/>
        </span>
        <xsl:if test="$hitNoAll &gt; 1">
            <!--<p><xsl:value-of select="count(//exist:match)"/> _<xsl:value-of select="$hitNo"/></p>-->
            <xsl:text> [</xsl:text>
            <a style="font-weight:900;font-size:larger;">
                <xsl:attribute name="href">
                    <xsl:text>#hit</xsl:text>
                    <xsl:value-of select="$hitNoAll - 1"/>
                </xsl:attribute>
                <xsl:attribute name="title">
                    <xsl:text>voriger Treffer</xsl:text>
                </xsl:attribute>
                <xsl:text>←</xsl:text>
            </a>
            <xsl:text>]</xsl:text>
        </xsl:if>
        <xsl:if test="$hitNoAll &lt; count(//exist:match)">
            <!--<p><xsl:value-of select="count(//exist:match)"/> _<xsl:value-of select="$hitNo"/></p>-->
            <xsl:text> [</xsl:text>
            <a style="font-weight:900;font-size:larger;">
                <xsl:attribute name="href">
                    <xsl:text>#hit</xsl:text>
                    <xsl:value-of select="$hitNoAll+1"/>
                </xsl:attribute>
                <xsl:attribute name="title">
                    <xsl:text>nächster Treffer</xsl:text>
                </xsl:attribute>
                <xsl:text>→</xsl:text>
            </a>
            <xsl:text>]</xsl:text>
        </xsl:if>
    </xsl:template>


    <xsl:template match="tei:term">
	    <a>
	        <xsl:attribute name="id">
	            <xsl:value-of select="generate-id()"/>
	        </xsl:attribute>
	        <xsl:attribute name="href">

	            <xsl:value-of select="@ref"/>

	        </xsl:attribute>
	        <xsl:attribute name="class">
	            <xsl:text>rs-ref</xsl:text>
	        </xsl:attribute>
	        <xsl:apply-templates/>
	    </a>
    </xsl:template>

    <xsl:template match="tei:rs">

        <xsl:choose>
            <xsl:when test="@ref=concat('#',$q)">
                <xsl:variable name="hitNo">
                    <xsl:number level="any" count="tei:rs[@ref=concat('#',$q)]"/>
                </xsl:variable>
                <a>
                    <xsl:attribute name="name">
                        <xsl:text>hit</xsl:text>
                        <xsl:value-of select="$hitNo"/>
                    </xsl:attribute>
                    <xsl:text> </xsl:text>
                </a>
                <span style="background-color:yellow;">
                    <xsl:choose>
                        <xsl:when test="@type='person'">
                            <a>
                                <xsl:attribute name="href">
                                   <!-- <xsl:text>javascript:show_annotationlayer('</xsl:text>-->
                                    <!--<xsl:value-of select="$dir"/>
                                    <xsl:text>','register/listPerson.xml'</xsl:text>
                                    <xsl:text>,'show_person.xsl','</xsl:text>-->
                                    <xsl:value-of select="substring(@ref,2)"/>
                                    <!--<xsl:text>',300,500)</xsl:text>-->
                                </xsl:attribute>
                                <xsl:apply-templates/>
                            </a>
                        </xsl:when>
                       <!-- <xsl:when test="@type='corporate' or @type='org'">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:text>javascript:show_annotationlayer('</xsl:text>
                                    <xsl:value-of select="$dir"/>
                                    <xsl:text>','register/listPlace.xml'</xsl:text>
                                    <xsl:text>,'show_place.xsl','</xsl:text>
                                    <xsl:value-of select="substring(@ref,2)"/>
                                    <xsl:text>',300,500)</xsl:text>
                                </xsl:attribute>
                                <xsl:apply-templates/>
                            </a>
                        </xsl:when>            -->
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
                <xsl:if test="$hitNo &gt; 1">
                    <xsl:text> [</xsl:text>
                    <a style="font-weight:900;font-size:larger;">
                        <xsl:attribute name="href">
                            <xsl:text>#hit</xsl:text>
                            <xsl:value-of select="$hitNo - 1"/>
                        </xsl:attribute>
                        <xsl:attribute name="title">
                            <xsl:text>voriger Treffer</xsl:text>
                        </xsl:attribute>
                        <xsl:text>←</xsl:text>
                    </a>
                    <xsl:text>]</xsl:text>
                </xsl:if>
                <xsl:if test="$hitNo &lt; count(//tei:rs[@ref=concat('#',$q)])">
                    <xsl:text> [</xsl:text>
                    <a style="font-weight:900;font-size:larger;">
                        <xsl:attribute name="href">
                            <xsl:text>#hit</xsl:text>
                            <xsl:value-of select="$hitNo + 1"/>
                        </xsl:attribute>
                        <xsl:attribute name="title">
                            <xsl:text>nächster Treffer</xsl:text>
                        </xsl:attribute>
                        <xsl:text>→</xsl:text>
                    </a>
                    <xsl:text>]</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>


                <xsl:choose>
                    <xsl:when test="@type='abbreviation'">
                        <a href="#" class="tooltip">
                            <span class="custom info">
                                <xsl:value-of select="//tei:list/tei:item[@xml:id =substring(current()/@ref,2)]/*[position()=1]"/>
                            </span>
                            <xsl:apply-templates/>
                        </a>
                          </xsl:when>

                    <xsl:when test="@type='symbol'">
                        <a href="#" class="tooltip">
                            <span class="custom info">
                                <xsl:value-of select="//tei:list/tei:item[@xml:id =substring(current()/@ref,2)]/*"/>
                            </span>
                            <xsl:apply-templates/>
                        </a>
                    </xsl:when>

                    <xsl:when test="@type='person'">
                        <a>
                            <xsl:attribute name="id">
                                <xsl:value-of select="generate-id()"/>
                            </xsl:attribute>
                            <xsl:attribute name="href">

                                <xsl:value-of select="@ref"/>

                            </xsl:attribute>
                            <xsl:attribute name="class">
                                <xsl:text>rs-ref</xsl:text>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </a>
                    </xsl:when>

                    <xsl:when test="@type='place'">
                        <a>
                            <xsl:attribute name="id">
                                <xsl:value-of select="generate-id()"/>
                            </xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:value-of select="@ref"/>
                            </xsl:attribute>
                            <xsl:attribute name="class">
                                <xsl:text>rs-ref</xsl:text>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </a>
                    </xsl:when>

                    <xsl:when test="@type='org'">
                        <a>
                            <xsl:attribute name="id">
                                <xsl:value-of select="generate-id()"/>
                            </xsl:attribute>
                            <xsl:attribute name="href">
                                <xsl:value-of select="@ref"/>
                            </xsl:attribute>
                            <xsl:attribute name="class">
                                <xsl:text>rs-ref</xsl:text>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </a>
                    </xsl:when>

                    <xsl:when test="@type='bibl'">
                        <xsl:apply-templates/>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="tei:bibl/tei:ref">
        <xsl:choose>

            <xsl:when test="@type='bibl' ">
                <a>
                    <xsl:attribute name="href">
                        <xsl:text>javascript:show_annotation('edoc/ed000228','register/listBibl.xml','show_bibl.xsl','</xsl:text>
                        <xsl:value-of select="substring(@target,2)"/>
                        <xsl:text>',300,500);</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                        <xsl:value-of
                            select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listBibl/tei:bibl[@xml:id =substring(current()/@ref,2)]"/>
                        <xsl:text> </xsl:text>
                        <xsl:if
                            test="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listBibl/tei:bibl[@xml:id =substring(current()/@ref,2)]/tei:nameLink">
                            <xsl:text> </xsl:text>
                            <xsl:value-of
                                select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listBibl/tei:bibl[@xml:id =substring(current()/@ref,2)]/tei:nameLink"/>
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="rdf:RDF">
        <xsl:value-of select="."/>
    </xsl:template>

    <!-- Templateregel zur Erzeugung eines Index-Registers am Seitenende, das via css ausgeblendet wird -->

    <xsl:template name="gloss_foot">
    	<xsl:for-each select="//tei:list[@type='gloss']/tei:item">
        <div id="{@xml:id}">
            <xsl:attribute name="class">
                <xsl:text>term-ref</xsl:text>
            </xsl:attribute>
            <span class="term">
            		<b><xsl:apply-templates select="tei:label" /></b><br />
                <xsl:apply-templates select="tei:list/tei:item" mode="gloss" />
            </span>
        </div>
    	</xsl:for-each>
    </xsl:template>

	<xsl:template match="tei:item" mode="gloss">
		<i><xsl:value-of select="."/></i><br />
	</xsl:template>

    <xsl:template match="tei:person"/>
    <xsl:template match="tei:person[key('entity-ref', @xml:id)]">
        <xsl:call-template name="format-person"/>
    </xsl:template>

    <!-- Wird mit einem tei:person als Kontextknoten aufgerufen und liefert eine für die Anzeige vorbereitete Übersicht zur Person -->
    <xsl:template name="format-person">
        <div id="{@xml:id}">
            <xsl:attribute name="class">
                <xsl:text>rs-ref</xsl:text>
            </xsl:attribute>


            <!-- TBD -->

            <xsl:if test="tei:persName/tei:name">
                <span><b>
                    <xsl:value-of select="tei:persName/tei:name/."/></b>
                </span><xsl:text> </xsl:text>
            </xsl:if>

            <xsl:if test="tei:persName/tei:forename">
                <span class="forename"><b>
                    <xsl:value-of select="tei:persName/tei:forename/."/></b>
                </span><xsl:text> </xsl:text>
            </xsl:if>

            <xsl:if test="tei:persName/tei:roleName">
                <span class="roleName">
                    <xsl:value-of select="tei:persName/tei:roleName/."/>
                </span><xsl:text> </xsl:text>
            </xsl:if>

            <xsl:if test="tei:persName/tei:nameLink">
                <span class="nameLink">
                    <xsl:value-of select="tei:persName/tei:nameLink/."/>
                </span><xsl:text> </xsl:text>
            </xsl:if>

            <xsl:if test="tei:persName/tei:placeName">
                <span class="placeName">
                    <xsl:value-of select="tei:persName/tei:placeName/."/>
                </span><xsl:text> </xsl:text>
            </xsl:if>

            <xsl:if test="tei:persName/tei:surname">
                <span class="surname">
                    <xsl:value-of select="tei:persName/tei:surname/."/>
                </span><xsl:text> </xsl:text>
            </xsl:if>

            <xsl:if test="tei:birth">
                <br/>
                <xsl:text>geb.: </xsl:text>
                <span class="birth">
                    <xsl:value-of select="tei:birth/."/>
                </span>
            </xsl:if>
            <xsl:if test="tei:death">
                <br/>
                <xsl:text>gest.: </xsl:text>
                <span class="death">
                    <xsl:value-of select="tei:death/."/>
                </span>
            </xsl:if>
            <xsl:if test="tei:note">
                <br/>
                <xsl:text>Anm.: </xsl:text>
                <span class="note">
                    <xsl:value-of select="tei:note/."/>
                </span>
            </xsl:if>
        </div>
    </xsl:template>


    <!-- Wird mit einem tei:org als Kontextknoten aufgerufen und liefert eine für die Anzeige vorbereitete Übersicht zur Person -->
     <xsl:template name="format-org">
                <div id="{@xml:id}">
                    <xsl:attribute name="class">
                        <xsl:text>rs-ref</xsl:text>
                    </xsl:attribute>
                </div>
     </xsl:template>

    <!-- Templateregel zur Erzeugung eines Index-Registers am Seitenende, das via css ausgeblendet wird -->

    <xsl:template match="tei:place"/>
    <xsl:template match="tei:place[key('entity-ref', @xml:id)]">
        <xsl:call-template name="format-place"/>
    </xsl:template>

    <!-- Wird mit einem tei:person als Kontextknoten aufgerufen und liefert eine für die Anzeige vorbereitete Übersicht zur Person -->
    <xsl:template name="format-place">
        <div id="{@xml:id}">
            <xsl:attribute name="class">
                <xsl:text>rs-ref</xsl:text>
            </xsl:attribute>




            <!-- TBD -->

            <xsl:if test="tei:placeName">
                <span class="placeName">
                    <xsl:value-of select="tei:placeName/."/>
                    <xsl:if test="tei:placeName[@ref]">
                        <br/>
                        <a target="_blank">
                            <xsl:attribute name="href">
                                <xsl:value-of select="tei:placeName/@ref"/>
                            </xsl:attribute>
                            weiterführende Informationen
                     </a>
                    </xsl:if>
                </span><xsl:text> </xsl:text>
            </xsl:if>


        </div>
    </xsl:template>
</xsl:stylesheet>
