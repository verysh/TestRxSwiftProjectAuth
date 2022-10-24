//
//  TaskListViewController.swift
//  TestRxSwiftProjectAuth
//
//  Created by 1 on 23.10.2022.
//

import UIKit

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import ReusableKit
import SnapKit
import RxViewController

final class TaskListViewController: BaseViewController, View {
    
    // MARK: Constants
    struct Reusable {
        static let taskCell = ReusableCell<TaskCell>()
    }
    
    // MARK: Properties
    private let dataSource = RxTableViewSectionedReloadDataSource<TaskListSection>(
        configureCell: { _, tableView, indexPath, reactor in
            let cell = tableView.dequeue(Reusable.taskCell, for: indexPath)
            cell.reactor = reactor
            return cell
        })
    
    private let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    private let tableView = UITableView().then {
        $0.allowsSelectionDuringEditing = true
        $0.register(Reusable.taskCell)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = self.addButtonItem
        self.reactor = reactor
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
    
    // MARK: Binding
    
    func bind(reactor: TaskListViewReactor) {
        // DataSource
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.dataSource.canEditRowAtIndexPath = { _, _  in true }
        self.dataSource.canMoveRowAtIndexPath = { _, _  in true }
        
        // Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.editButtonItem.rx.tap
            .map { Reactor.Action.toggleEditing }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.itemSelected
            .filterNot(reactor.state.map { $0.isEditing })
            .map { indexPath in .toggleTaskDone(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.itemDeleted
            .map(Reactor.Action.deleteTask)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.itemMoved
            .map(Reactor.Action.moveTask)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.addButtonItem.rx.tap
            .map(reactor.reactorForCreatingTask)
            .subscribe(onNext: { [weak self] reactor in
                guard let `self` = self else { return }
                guard let viewController = UIStoryboard.taskEditVC else { return }
                viewController.reactor = reactor
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.modelSelected(type(of: self.dataSource).SectionModelSnapshot.Item.self)
            .filter(reactor.state.map { $0.isEditing })
            .map(reactor.reactorForEditingTask)
            .subscribe(onNext: { [weak self] reactor in
                guard let `self` = self else { return }
                guard let viewController = UIStoryboard.taskEditVC else { return }
                viewController.reactor = reactor
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.asObservable().map { $0.sections }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable().map { $0.isEditing }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isEditing in
                guard let `self` = self else { return }
                self.navigationItem.leftBarButtonItem?.title = isEditing ? "Done" : "Edit"
                self.navigationItem.leftBarButtonItem?.style = isEditing ? .done : .plain
                self.tableView.setEditing(isEditing, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
}


// MARK: - UITableViewDelegate

extension TaskListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let reactor = self.dataSource[indexPath]
        return TaskCell.height(fits: tableView.width, reactor: reactor)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
