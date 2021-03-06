//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Юлия Филимонова on 04.04.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    private var post: [Post] = Post.makePost()
    private var photoPost: [PhotoPost] = PhotoPost.makePhotoPost()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = .zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.identifier)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        addView()
    }

    private func addView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return photoPost.count
        } else {
            return post.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.identifier, for: indexPath) as! PhotosTableViewCell
            cell.setupCell(photoPost[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            cell.likeDelegate = self
            cell.setupCell(post[indexPath.row])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else { return .zero }
        return 220
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let header = ProfileHeaderView()
        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let photosVC = PhotosViewController()
            navigationController?.pushViewController(photosVC, animated: true)
        } else {
            post[indexPath.row].views += 1
            let detailPostVC = DetailPostViewController()
            detailPostVC.setupCell(post[indexPath.row])
            detailPostVC.detailLikeDelegate = self
            navigationController?.pushViewController(detailPostVC, animated: true)
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard indexPath.section == 1 else { return .none }
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            post.remove(at: indexPath.row)
            tableView.reloadData()
        }

    }
}

// MARK: - TapLikeDelegate

extension ProfileViewController: TapLikeDelegate {
    func tapLikesLabel(cell: PostTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            post[indexPath.row].likes += 1
        }
        tableView.reloadData()
    }
}

extension ProfileViewController: DetailLikeDelegate {
    func tapDeatailLike(like: Int, id: Int) {
        post[id].likes = like
        tableView.reloadData()
    }
}
