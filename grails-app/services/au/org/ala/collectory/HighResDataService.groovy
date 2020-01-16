package au.org.ala.collectory

import grails.converters.JSON
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import org.apache.commons.httpclient.util.URIUtil

@Transactional
class HighResDataService {

    def grailsApplication

    //static final String fqForHighRes = 'month:06' //TODO: when Steve's part is done this should be something like high_resolution:true
    static final String fqForHighRes = 'individual_count:3' //TODO: when Steve's part is done this should be something like high_resolution:true
    /**
     * Return JSON representation of species with high resolution records held in data provider's datasets
     *
     * @param uid - uid of data provider
     */
    def getHighResSpeciesForDataProvider(def uid) {
        if (uid) {

            def url = grailsApplication.config.biocacheServicesUrl + "/occurrences/search?q=*:*&fq=" + fqForHighRes + "&fq=data_provider_uid:" + uid + "&facets=names_and_lsid&pageSize=0&facet=on&flimit=-1"
            //&sort=names_and_lsid%20ASC"
            log.info("Get high resolution species for data provider from: " + url)
            def js = new JsonSlurper()
            def biocacheSearch = js.parse(new URL(url), "UTF-8")
            if (biocacheSearch.totalRecords == 0) {
                return biocacheSearch.facetResults
            }

            List highresSpecies = []
            biocacheSearch.facetResults[0].fieldResult.each { result ->
                log.info(result)
                def spParts = result.label.split('\\|')
                if (spParts?.size()?:0 > 3) {
                    highresSpecies << [
                            taxon     : spParts[0],
                            lsid      : spParts[1],
                            commonname: spParts[2],
                            records   : result.count
                    ]
                }
            }
            log.info("Resulting high resolution species = " + highresSpecies.toString())
            return highresSpecies

        } else {
            return null
        }
    }

    /**
     * Return JSON summary of records for a single species held in data provider's datasets
     *
     * @param lsid - uid of species
     * @param uid - uid of data provider
     */
    def getSpeciesHighResRecordsForDataProvider(def lsid, def uid) {
        if (uid && lsid) {
            def url = grailsApplication.config.biocacheServicesUrl + "/occurrences/search?q=*:*&fq=" + fqForHighRes + "&fq=data_provider_uid:" + uid + "&fq=taxon_concept_lsid:" + lsid + "&facets=data_resource_uid&pageSize=0&facet=on&flimit=-1"
            def js = new JsonSlurper()
            def biocacheSearch = js.parse(new URL(url), "UTF-8")
            log.info("biocacheSearch = " + biocacheSearch.toString())
            if (biocacheSearch.totalRecords == 0) {
                return biocacheSearch.facetResults
            }

            List datasetRecords = []
            biocacheSearch.facetResults[0].fieldResult.each { result ->
                def dsParts = result.fq.split(':')
                datasetRecords << [
                        label     : result.label,
                        dr_uid    : dsParts[1],
                        records   : result.count
                ]
            }
            return datasetRecords

        } else {
            return null
        }
    }
}
