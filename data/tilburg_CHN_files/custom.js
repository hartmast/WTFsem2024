"use strict";

var config = {
	staticBase: CONTEXT_URL + '/' + INDEX_ID + '/static/',
}

var isSearchPage = window.hasOwnProperty('vuexModules') && !!window.vuexModules.corpus;
var isArticlePage = !!$('.container.article').length;

if (isSearchPage) {
	// Fix up the interface when running an older version of the index.
	// TODO this breaks when done after init has finished, and that should be fixed.
	try {
		vuexModules.filters.actions.registerFilter({filter: {
			id: 'witnessYear-range',
			componentName: 'filter-range-multiple-fields',
	
			displayName: 'Year',
			description: 'Date this version of the text was written',
	
			metadata: {
				low: 'witnessYear_from',
				high: 'witnessYear_to'
			}
		}});
		vuexModules.filters.actions.registerFilter({filter: {
			id: 'witnessMonth-range',
			componentName: 'filter-range-multiple-fields',
	
			displayName: 'Month',
			description: 'Date this version of the text was written',
	
			metadata: {
				low: 'witnessMonth_from',
				high: 'witnessMonth_to',
				mode: 'strict'
			}
		}});
		vuexModules.filters.actions.registerFilter({filter: {
			id: 'witnessDay-range',
			componentName: 'filter-range-multiple-fields',
	
			displayName: 'Day',
			description: 'Date this version of the text was written',
	
			metadata: {
				low: 'witnessDay_from',
				high: 'witnessDay_to',
				mode: 'strict'
			}
		}});


		var groupsForFiltersSection = 
		[{
			tabname: 'General',
			subtabs: [{
				tabname: 'Title',
				fields: [
					'title',
					'titleLevel2',
					'titleLevel1',
				]
			}, {
				tabname: 'Author',
				fields: [
					'authorCombined', // (combined) level1 en 2
				]
			}, {
				tabname: 'Date',
				fields: [
					'witnessYear-range',
					'witnessMonth-range',
					'witnessDay-range',
					
					'witnessDay_from',
					'witnessDay_to',
					'witnessMonth_from',
					'witnessMonth_to',
					'witnessYear_from',
					'witnessYear_to',

					'grouping_year',
					'grouping_month',
					'grouping_day'
				]
			}, {
				tabname: 'Medium',
				fields: [
					'medium',
				]
			}, {
				tabname: 'Language',
				fields: [
					'languageVariant',
				]
			}, {
				tabname: 'IPR',
				fields: [
					'ipr'
				]
			}]
		}];

		var index = vuexModules.corpus.getState();
		
		// create preliminary groups
		var seenInGeneralGroup = {};
		const availableFields = index.metadataFields;
		const blacklabgroups = groupsForFiltersSection.map(group => ({
			id: group.tabname === 'General' ? 'Common' : group.tabname, // replace the "general" name with just 'Common' 
			entries: group.subtabs.flatMap(subtab => subtab.fields).filter(id => {
				const available = availableFields[id];
				if (!available) console.warn('Field ' + id + ' does not exist, ignoring');
				if (seenInGeneralGroup[id]) return false;
				if (group.tabname === 'General') seenInGeneralGroup[id] = true; 
				return available;
			}),
			isRemainderGroup: false
		}));

		// create remainer
		const seenIds = new Set();
		const remainderIds = [];
		blacklabgroups.forEach(g => g.entries.forEach(id => seenIds.add(id)));
		Object.keys(availableFields).forEach(id => {
			if (!seenIds.has(id)) {
				remainderIds.push(id);
				seenIds.add(id);
			}
		});
		remainderIds.sort((a, b) => availableFields[a].displayName.localeCompare(availableFields[b].displayName));
		blacklabgroups.push({
			id: 'Metadata',
			entries: remainderIds,
			isRemainderGroup: true
		});

		// clear existing groups and overwrite with our more specific version
		index.metadataFieldGroups.splice(0, index.metadataFieldGroups.length);
		blacklabgroups.forEach(group => index.metadataFieldGroups.push(group));

		hooks.beforeStateLoaded = () => {
			// set enhanced groups
			const filterState = vuexModules.filters.getState();
			filterState.filterGroups.splice(0, filterState.filterGroups.length);
			groupsForFiltersSection.forEach(group => filterState.filterGroups.push(group)); // remainder is just not in there or something probably.
		}
	} catch (e) {
		console.error(e);
	}

	// Only run on search page, configure some properties before the page is rendered for the first time (which happens on document.ready)
	var x = true;
	var ui = vuexModules.ui.actions;
	ui.helpers.configureAnnotations([
		[                       ,    'EXTENDED'    ,    'ADVANCED'    ,    'EXPLORE'    ,    'SORT'    ,    'GROUP'    ,    'RESULTS'    ,    'CONCORDANCE'    ],
		
		// Main
		['word'                 ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,          x          ],
		['lemma'                ,        x         ,        x         ,        x        ,      x       ,       x       ,        x        ,          x          ],
		['pos'                  ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,                     ],
		['pos_full'             ,                  ,                  ,                 ,      x       ,       x       ,        x        ,          x          ],
		
		// PoS features
		['pos_type'             ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,                     ],
		['pos_subtype'          ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,                     ],
		['pos_gender'           ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,                     ],
		['pos_number'           ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,                     ],
		['pos_person'           ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,                     ],
		['pos_tense'            ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,                     ],
		['pos_mood'             ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,                     ],
		['pos_position'         ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,                     ],
		['pos_case'             ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,                     ],
		['pos_finiteness'       ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,                     ],
		['pos_part_of_multiword',        x         ,        x         ,        x        ,      x       ,       x       ,                 ,                     ],
		['pos_degree'           ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,                     ],
		['pos_formal'           ,        x         ,        x         ,        x        ,      x       ,       x       ,                 ,                     ],
		
		// (not in any group)
		['punct'                ,                  ,                  ,                 ,              ,               ,                 ,                     ],
		['starttag'             ,                  ,                  ,                 ,              ,               ,                 ,                     ],
	]);

	ui.helpers.configureMetadata([
		[                              ,    'FILTER'    ,    'SORT'    ,    'GROUP'    ,    'RESULTS/HITS'    ,    'RESULTS/DOCS'    ,    'EXPORT'    ],
		
		// Common
		['title'                       ,       x        ,      x       ,       x       ,                      ,                      ,                ],
		['titleLevel2'                 ,       x        ,      x       ,       x       ,                      ,                      ,                ],
		['titleLevel1'                 ,       x        ,      x       ,       x       ,                      ,                      ,                ],
		['authorCombined'              ,       x        ,      x       ,       x       ,                      ,                      ,                ],
		['witnessDay_from'             ,                ,              ,               ,                      ,                      ,                ],
		['witnessDay_to'               ,                ,              ,               ,                      ,                      ,                ],
		['witnessMonth_from'           ,                ,              ,               ,                      ,                      ,                ],
		['witnessMonth_to'             ,                ,              ,               ,                      ,                      ,                ],
		['witnessYear_from'            ,                ,              ,               ,                      ,                      ,                ],
		['witnessYear_to'              ,                ,              ,               ,                      ,                      ,                ],
		['grouping_year'               ,                ,      x       ,       x       ,                      ,          x           ,                ],
		['grouping_month'              ,                ,      x       ,       x       ,                      ,                      ,                ],
		['grouping_day'                ,                ,      x       ,       x       ,                      ,                      ,                ],
		['medium'                      ,       x        ,      x       ,       x       ,                      ,                      ,                ],
		['languageVariant'             ,       x        ,      x       ,       x       ,                      ,                      ,                ],
		['ipr'                         ,                ,              ,               ,                      ,                      ,                ],
		
		// Newspapers
		// titleLevel2 in common group: only filter here
		['newspapers_titleLevel2'      ,                ,              ,               ,                      ,                      ,                ],
		['newspapers_authorLevel1'     ,                ,              ,               ,                      ,                      ,                ],
		['newspapers_languageVariant'  ,                ,              ,               ,                      ,                      ,                ],
		['articleClass'                ,                ,              ,               ,                      ,                      ,                ],
		['articleSeries'               ,                ,              ,               ,                      ,                      ,                ],
		['sectionColumn'               ,                ,              ,               ,                      ,                      ,                ],
		['newspaperSection'            ,                ,              ,               ,                      ,                      ,                ],
		['properties'                  ,                ,              ,               ,                      ,                      ,                ],
		['keywords'                    ,                ,              ,               ,                      ,                      ,                ],
		['subject'                     ,                ,              ,               ,                      ,                      ,                ],
		['newspapers_topic'            ,                ,              ,               ,                      ,                      ,                ],
		['settingLocation'             ,                ,              ,               ,                      ,                      ,                ],
		['settingOrganization'         ,                ,              ,               ,                      ,                      ,                ],
		['settingPerson'               ,                ,              ,               ,                      ,                      ,                ],
		
		// Easy Language
		// all these in common group: only filter here
		['easyLanguage_title'          ,                ,              ,               ,                      ,                      ,                ],
		['easyLanguage_titleLevel2'    ,                ,              ,               ,                      ,                      ,                ],
		['easyLanguage_titleLevel1'    ,                ,              ,               ,                      ,                      ,                ],
		['easyLanguage_authorCombined' ,                ,              ,               ,                      ,                      ,                ],
		['easyLanguage_languageVariant',                ,              ,               ,                      ,                      ,                ],
		['levelBasilex'                ,                ,              ,               ,                      ,                      ,                ],
		['gradeBasilex'                ,                ,              ,               ,                      ,                      ,                ],
		['maintypeBasilex'             ,                ,              ,               ,                      ,                      ,                ],
		['typeBasilex'                 ,                ,              ,               ,                      ,                      ,                ],
		['subtypeBasilex'              ,                ,              ,               ,                      ,                      ,                ],
		['targetAudience'              ,                ,              ,               ,                      ,                      ,                ],
		
		// ANW-Corpus
		// titleLevel2, authorLevel2 in common group: only show in filters section
		['anw_titleLevel2'             ,                ,              ,               ,                      ,                      ,                ],
		['anw_authorLevel2'            ,                ,              ,               ,                      ,                      ,                ],
		['anw_topic'                   ,                ,              ,               ,                      ,                      ,                ],
		['lemma'                       ,                ,              ,               ,                      ,                      ,                ],
		
		// (not in any group)
		['author'                      ,                ,              ,               ,                      ,                      ,                ],
		['authorLevel1'                ,                ,              ,               ,                      ,                      ,                ],
		['authorLevel2'                ,                ,              ,               ,                      ,                      ,                ],
		['corpusProvenance'            ,                ,              ,               ,                      ,                      ,                ],
		['fromInputFile'               ,                ,              ,               ,                      ,                      ,                ],
		['pid'                         ,                ,              ,               ,                      ,                      ,                ],
		['pubYear_from'                ,                ,              ,               ,                      ,                      ,                ],
		['pubYear_to'                  ,                ,              ,               ,                      ,                      ,                ],
		['sourceID'                    ,                ,              ,               ,                      ,                      ,                ],
		['textYear_from'               ,                ,              ,               ,                      ,                      ,                ],
		['textYear_to'                 ,                ,              ,               ,                      ,                      ,                ],
		['titleCombined'               ,                ,              ,               ,                      ,                      ,                ],
		['topic'                       ,                ,              ,               ,                      ,                      ,                ],
	]);

	ui.search.extended.splitBatch.enable(false);
	ui.global.pageGuide.enable(false);

	ui.search.extended.within.enable(true);
	// NOTE 21-06-2021 - This can be removed soon, when the newest index hits the servers and we no longer index inline lb and pb elements anyway. Until then: use this hardcoded whitelist of inline tags.
	vuexModules.ui.getState().search.extended.within.elements.splice(0, vuexModules.ui.getState().search.extended.within.elements.length);
	vuexModules.ui.getState().search.extended.within.elements.push({
		label: 'Document',
		value: '',
	}, {
		label: 'Sentence',
		value: 's',
	}, {
		label: 'Paragraph',
		value: 'p'
	});

	ui.results.shared.exportEnabled(false); 
	ui.dropdowns.groupBy.metadataGroupLabelsVisible(false);
	ui.results.shared.totalsTimeoutDurationMs(-1);
	
	vuexModules.ui.getState().global.errorMessage = function(error, context) {
		return originalError(error) + '<br>' + error.message + '<br>' + `If this is unexpected, please <a href="mailto:chn@ivdnt.org?body=${encodeURIComponent(
			`Error info\nMessage: [${error.statusText}] ${error.title} - ${error.message}\nurl: ${window.location.href}`
		)}">mail us at chn@ivdnt.org</a>.`
	}
	var originalTitle = vuexModules.ui.getState().results.shared.getDocumentSummary;
	vuexModules.ui.getState().results.shared.getDocumentSummary = function(doc, fields) {
		if (doc.medium.includes('newspaper')) {
			if (doc.titleLevel1 && doc.titleLevel1[0]) return doc.titleLevel1[0];
			// else no actual title for this article
			return 'Artikel zonder titel' + ((doc.titleLevel2 && doc.titleLevel2[0]) ? ' uit ' + doc.titleLevel2[0] : '');
		}
		// non-newspaper article 
		// return the normal title
		return originalTitle(doc, fields);
	}

	vuexModules.tagset.actions.load(config.staticBase + 'tagset.json');
}

if (isArticlePage) {
	$(document).ready(function() {
		vuexModules.root.actions.distributionAnnotation({
			displayName: 'Token/Part of Speech Distribution',
			id: 'pos'
		});
		vuexModules.root.actions.growthAnnotations({
			displayName: 'Vocabulary Growth',
			annotations: [{
				displayName: 'Word types',
				id: 'word'
			}, {
				displayName: 'Lemmas',
				id: 'lemma'
			}],
		});
		// vuexModules.root.actions.baseColor(config.baseColor);

		vuexModules.root.actions.statisticsTableFn(function(document, snippet) {
			var ret = {};
			ret['Tokens'] = document.docInfo.lengthInTokens;
			ret['Types'] = Object.keys(snippet.match['pos'].reduce(function(acc, v) {
				acc[v] = true;
				return acc;
			}, {})).length;
			ret['Lemmas'] = Object.keys(snippet.match['lemma'].reduce(function(acc, v) {
				acc[v] = true;
				return acc;
			}, {})).length

			// Ratio is length / unique words (see https://github.com/INL/corpus-frontend/issues/233)
			var ratio = ret['Tokens'] / Object.keys(snippet.match['word'].reduce(function(acc, v) {
				acc[v] = true;
				return acc;
			}, {})).length;
			var invRatio = 1/ratio;
			ret['Type/token ratio'] = '1/'+ratio.toFixed(1)+' ('+invRatio.toFixed(2)+')';

			return ret;
		});
	});
}
