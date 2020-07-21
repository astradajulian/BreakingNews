//
//  HeadlineSourcesDataSource.swift
//  BreakingNews
//
//  Created by Julian Astrada on 07/07/2020.
//  Copyright © 2020 Julian Astrada. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TopHeadlinesViewModel {
    
    private let disposeBag = DisposeBag()
        
    let headlineSources: PublishSubject<[Article]> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<ApiError?> = PublishSubject()
    
    init(country: String) {
        fetchTopHeadlines(country: country)
    }
    
    private func fetchTopHeadlines(country: String) {
        loading.onNext(true)
        
        APIManager.getTopHeadlines(country: country).observeOn(MainScheduler.instance).subscribe(onSuccess: {[unowned self] (data) in
            self.loading.onNext(false)
            
            self.headlineSources.onNext(data.articles)
        }, onError: {[unowned self] (error) in
            self.loading.onNext(false)
            
            self.error.onNext(error as? ApiError)
        }).disposed(by: disposeBag)
    }
    
}
